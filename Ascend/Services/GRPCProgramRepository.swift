import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2

@available(iOS 18.0, *)
class GRPCProgramRepository: WorkoutProgramRepository {
    static let shared = GRPCProgramRepository()

    private let clientManager = GRPCClientManager.shared

    private static let defaultProgramId = "ace0293a-aee1-4b5b-bfd5-6311951b28a7"

    func getAllPrograms() async throws -> [WorkoutProgram] {
        guard let program = try await fetchProgram(serverId: Self.defaultProgramId) else { return [] }
        return [program]
    }

    func getProgram(id: UUID) async throws -> WorkoutProgram? {
        return try await fetchProgram(serverId: id.uuidString)
    }

    private func fetchProgram(serverId: String) async throws -> WorkoutProgram? {
        return try await clientManager.withClient { grpcClient in
            let programClient = Program_ProgramService.Client(wrapping: grpcClient)

            let programResponse: Program_GetProgramResponse = try await programClient.getProgram(
                .with { $0.id = serverId }
            )

            var days: [WorkoutDay] = []
            for protoDay in programResponse.days {
                let dayResponse = try await programClient.getProgramDay(
                    .with { $0.id = protoDay.id }
                )
                days.append(Self.mapWorkoutDay(from: dayResponse))
            }

            return WorkoutProgram(
                name: programResponse.name,
                workouts: days,
                serverId: programResponse.id
            )
        }
    }

    func saveProgram(_ program: WorkoutProgram) async throws {}
    func deleteProgram(id: UUID) async throws {}

    // MARK: - Mapping

    private static func mapWorkoutDay(from proto: Program_GetProgramDayResponse) -> WorkoutDay {
        let label = proto.label
        let workoutType = deriveWorkoutType(from: label)
        let variant = deriveVariant(from: label)

        let exercises = proto.exercises.map { mapExercise(from: $0) }
        let dayId = UUID(uuidString: proto.id) ?? UUID()

        return WorkoutDay(
            id: dayId,
            name: label,
            type: workoutType,
            variant: variant,
            warmup: [],
            exercises: exercises,
            estimatedDuration: 75
        )
    }

    private static func mapExercise(from proto: Program_ProgramExercise) -> Exercise {
        let tag = deriveTag(from: proto.muscleGroup)
        let type: ExerciseType = proto.isAmrap ? .amrap : (proto.isTimed ? .hold : .reps)
        let exerciseId = UUID(uuidString: proto.id) ?? UUID()

        return Exercise(
            id: exerciseId,
            name: proto.name,
            sets: Int(proto.sets),
            repRange: RepRange(min: Int(proto.repMin), max: Int(proto.repMax)),
            targetWeight: 0,
            restSeconds: deriveRestSeconds(tag: tag, sets: Int(proto.sets)),
            tag: tag,
            type: type
        )
    }

    private static func deriveWorkoutType(from label: String) -> WorkoutType {
        let lower = label.lowercased()
        if lower.contains("push") { return .push }
        if lower.contains("pull") { return .pull }
        return .legs
    }

    private static func deriveVariant(from label: String) -> String {
        if label.hasSuffix("A") { return "A" }
        if label.hasSuffix("B") { return "B" }
        return ""
    }

    private static func deriveTag(from muscleGroup: String) -> ExerciseTag {
        switch muscleGroup.lowercased() {
        case "chest", "shoulders", "triceps": return .upperPush
        case "back", "biceps": return .upperPull
        case "quadriceps", "glutes": return .squat
        case "hamstrings": return .hinge
        default: return .isolation
        }
    }

    private static func deriveRestSeconds(tag: ExerciseTag, sets: Int) -> Int {
        switch tag {
        case .squat, .hinge: return 150
        case .upperPush, .upperPull: return sets >= 4 ? 150 : 120
        case .isolation: return 60
        }
    }
}
