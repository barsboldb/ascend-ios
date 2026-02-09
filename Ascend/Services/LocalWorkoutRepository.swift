import Foundation;

class LocalWorkoutRepository: WorkoutProgramRepository {
    static let shared = LocalWorkoutRepository();

    private var programs: [WorkoutProgram] = [];

    init() {
        self.programs = [SampleData.twicePerWeekPPL];
    }

    func getAllPrograms() async throws -> [WorkoutProgram] {
        return programs;
    }

    func getProgram(id: UUID) async throws -> WorkoutProgram? {
        return programs.first { $0.id == id }
    }

    func saveProgram(_ program: WorkoutProgram) async throws {
        if let index = programs.firstIndex(where: { $0.id == program.id }) {
            programs[index] = program
        } else {
            programs.append(program)
        }
    }

    func deleteProgram(id: UUID) async throws {
        programs.removeAll { $0.id == id }
    }
}
