import Foundation;

protocol WorkoutProgramRepository {
    func getAllPrograms() async throws -> [WorkoutProgram]
    func getProgram(id: UUID) async throws -> WorkoutProgram?
    func saveProgram(_ program: WorkoutProgram) async throws
    func deleteProgram(id: UUID) async throws
}
