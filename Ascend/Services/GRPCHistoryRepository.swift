import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import SwiftProtobuf

@available(iOS 18.0, *)
actor GRPCHistoryRepository: WorkoutHistoryRepository {
    static let shared = GRPCHistoryRepository()

    private let clientManager = GRPCClientManager.shared

    func getAllSessions() async throws -> [WorkoutSession] {
        return try await fetchRecent(limit: 100)
    }

    func getSessions(for workoutDayId: UUID) async throws -> [WorkoutSession] {
        let all = try await fetchRecent(limit: 100)
        return all.filter { $0.workoutDayId == workoutDayId }
    }

    func getRecentSessions(limit: Int) async throws -> [WorkoutSession] {
        return try await fetchRecent(limit: limit)
    }

    private func fetchRecent(limit: Int) async throws -> [WorkoutSession] {
        return try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            let response = try await sessionClient.listRecentSessions(
                .with { $0.limit = Int32(limit) }
            )
            return response.sessions.map { Self.mapFromProto($0) }
        }
    }

    func saveSession(_ session: WorkoutSession) async throws {
        let request = Self.mapToCreateRequest(session)
        _ = try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            return try await sessionClient.createSession(request)
        }
    }

    func deleteSession(id: UUID) async throws {
        _ = try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            return try await sessionClient.deleteSession(.with { $0.id = id.uuidString })
        }
    }

    func updateSet(id: UUID, weight: Double, reps: Int, rpe: Int?) async throws {
        _ = try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            return try await sessionClient.updateExerciseSet(.with {
                $0.id = id.uuidString
                $0.weightKg = Float(weight)
                $0.reps = Int32(reps)
                if let rpe { $0.rpe = Int32(rpe) }
                $0.failure = false
            })
        }
    }

    func getLastPerformedExercise(named exerciseName: String) async throws -> CompletedExercise? {
        // Name-based lookup not directly supported; fallback to recent sessions
        let recent = try await fetchRecent(limit: 20)
        for session in recent {
            if let match = session.completedExercises.first(where: { $0.exerciseName == exerciseName }) {
                return match
            }
        }
        return nil
    }

    func getLastPerformedExercise(exerciseId: UUID) async throws -> CompletedExercise? {
        return try await clientManager.withClient { grpcClient in
            let sessionClient = Session_SessionService.Client(wrapping: grpcClient)
            let response = try await sessionClient.getLastSetsForExercise(
                .with { $0.exerciseID = exerciseId.uuidString }
            )
            guard response.found else { return nil }

            let sets = response.sets.map { protoSet in
                CompletedSet(
                    reps: Int(protoSet.reps),
                    weight: Double(protoSet.weightKg),
                    rpe: protoSet.hasRpe ? Int(protoSet.rpe) : nil,
                    completed: true
                )
            }
            return CompletedExercise(
                exerciseId: UUID(uuidString: response.exerciseID),
                exerciseName: response.exerciseName,
                sets: sets
            )
        }
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
                if let rpe = set.rpe {
                    pbSet.rpe = Int32(rpe)
                }
                return pbSet
            }
        }
        return request
    }

    private static func mapFromProto(_ proto: Session_SessionWithExercises) -> WorkoutSession {
        let workoutDayId = UUID(uuidString: proto.programDayID) ?? UUID()
        let date = proto.hasStartedAt ? proto.startedAt.date : Date()

        let completedExercises = proto.exercises.map { protoExercise -> CompletedExercise in
            let exerciseId = UUID(uuidString: protoExercise.exerciseID)
            let sets = protoExercise.sets.map { protoSet in
                CompletedSet(
                    id: UUID(uuidString: protoSet.id) ?? UUID(),
                    reps: Int(protoSet.reps),
                    weight: Double(protoSet.weightKg),
                    rpe: protoSet.hasRpe ? Int(protoSet.rpe) : nil,
                    completed: true
                )
            }
            return CompletedExercise(exerciseId: exerciseId, exerciseName: protoExercise.exerciseName, sets: sets)
        }

        let duration: Int? = {
            guard proto.hasStartedAt && proto.hasEndedAt else { return nil }
            return Int(proto.endedAt.date.timeIntervalSince(proto.startedAt.date) / 60)
        }()

        return WorkoutSession(
            id: UUID(uuidString: proto.id) ?? UUID(),
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
