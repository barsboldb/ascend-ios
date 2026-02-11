import Foundation

class LocalHistoryRepository: WorkoutHistoryRepository {
    static let shared = LocalHistoryRepository()  

    private var sessions: [WorkoutSession] = []

    init() {
        self.sessions = SampleData.workoutHistory
    }
    func getAllSessions() async throws -> [WorkoutSession] {
        return sessions.sorted { $0.date > $1.date }
    }

    func getSessions(for workoutDayId: UUID) async throws -> [WorkoutSession] {
        return sessions
            .filter { $0.workoutDayId == workoutDayId }
            .sorted { $0.date > $1.date }
    }

    func getRecentSessions(limit: Int) async throws -> [WorkoutSession] {
        return sessions
            .sorted { $0.date > $1.date }
            .prefix(limit)
            .map { $0 }
    }

    func saveSession(_ session: WorkoutSession) async throws {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
    }

    func deleteSession(id: UUID) async throws {
        sessions.removeAll { $0.id == id }
    }
}
