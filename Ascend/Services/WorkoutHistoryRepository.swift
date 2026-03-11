import Foundation

protocol WorkoutHistoryRepository {
    func getAllSessions() async throws -> [WorkoutSession]
    func getSessions(for workoutDayId: UUID) async throws -> [WorkoutSession]
    func getRecentSessions(limit: Int) async throws -> [WorkoutSession]
    func saveSession(_ session: WorkoutSession) async throws
    func deleteSession(id: UUID) async throws

    func getLastPerformedExercise(named exerciseName: String) async throws -> CompletedExercise? 
}
