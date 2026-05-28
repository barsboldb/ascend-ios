import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import SwiftProtobuf

@available(iOS 18.0, *)
actor GRPCHistoryRepository: WorkoutHistoryRepository {
    static let shared = GRPCHistoryRepository()

    private let clientManager = GRPCClientManager.shared
    private var sessionCache: [WorkoutSession] = []

    func getAllSessions() async throws -> [WorkoutSession] {
        return sessionCache.sorted { $0.date > $1.date }
    }

    func getSessions(for workoutDayId: UUID) async throws -> [WorkoutSession] {
        return sessionCache
            .filter { $0.workoutDayId == workoutDayId }
            .sorted { $0.date > $1.date }
    }

    func getRecentSessions(limit: Int) async throws -> [WorkoutSession] {
        return Array(sessionCache.sorted { $0.date > $1.date }.prefix(limit))
    }

    func saveSession(_ session: WorkoutSession) async throws {
        let request = Self.mapToCreateRequest(session)

        let saved = try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            return try await sessionClient.createSession(request)
        }

        let cached = Self.mapFromProto(saved, fallback: session)
        if let index = sessionCache.firstIndex(where: { $0.id == cached.id }) {
            sessionCache[index] = cached
        } else {
            sessionCache.append(cached)
        }
    }

    func deleteSession(id: UUID) async throws {
        // Backend has no delete endpoint yet
        sessionCache.removeAll { $0.id == id }
    }

    func getLastPerformedExercise(named exerciseName: String) async throws -> CompletedExercise? {
        for session in sessionCache.sorted(by: { $0.date > $1.date }) {
            if let match = session.completedExercises.first(where: { $0.exerciseName == exerciseName }) {
                return match
            }
        }
        return nil
    }

    // MARK: - Mapping

    private static func mapToCreateRequest(_ session: WorkoutSession) -> Session_CreateSessionRequest {
        var request = Session_CreateSessionRequest()
        request.programDayID = session.workoutDayId.uuidString
        request.weekNumber = 1
        request.startedAt = Google_Protobuf_Timestamp(date: session.date)
        if let duration = session.duration {
            let ended = session.date.addingTimeInterval(TimeInterval(duration * 60))
            request.endedAt = Google_Protobuf_Timestamp(date: ended)
        }
        request.notes = session.notes ?? ""
        request.exercises = session.completedExercises.flatMap { exercise -> [Session_ExerciseSet] in
            exercise.sets.enumerated().map { index, set in
                var pbSet = Session_ExerciseSet()
                pbSet.exerciseID = exercise.exerciseId?.uuidString ?? ""
                pbSet.exerciseName = exercise.exerciseName
                pbSet.setNumber = Int32(index + 1)
                pbSet.weightKg = Float(set.weight)
                pbSet.reps = Int32(set.reps)
                pbSet.failure = false
                return pbSet
            }
        }
        return request
    }

    private static func mapFromProto(_ proto: Session_SessionWithExercises, fallback: WorkoutSession) -> WorkoutSession {
        let workoutDayId = UUID(uuidString: proto.programDayID) ?? fallback.workoutDayId
        let date = proto.hasStartedAt ? proto.startedAt.date : fallback.date

        let completedExercises = proto.exercises.map { protoExercise -> CompletedExercise in
            let exerciseId = UUID(uuidString: protoExercise.exerciseID)
            let sets = protoExercise.sets.map { protoSet in
                CompletedSet(reps: Int(protoSet.reps), weight: Double(protoSet.weightKg), completed: true)
            }
            return CompletedExercise(exerciseId: exerciseId, exerciseName: protoExercise.exerciseName, sets: sets)
        }

        let duration: Int? = {
            guard proto.hasStartedAt && proto.hasEndedAt else { return fallback.duration }
            return Int(proto.endedAt.date.timeIntervalSince(proto.startedAt.date) / 60)
        }()

        return WorkoutSession(
            workoutDayId: workoutDayId,
            date: date,
            completedExercises: completedExercises,
            duration: duration,
            notes: proto.notes.isEmpty ? nil : proto.notes
        )
    }
}

extension Google_Protobuf_Timestamp {
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(self.seconds) + TimeInterval(self.nanos) / 1_000_000_000)
    }
}
