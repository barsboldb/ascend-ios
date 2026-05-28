import SwiftUI

class ActiveWorkoutSession: ObservableObject {
    @Published var currentExerciseIndex: Int = 0
    @Published private(set) var saveError: String? = nil
    private(set) var completedExercises: [CompletedExercise] = []
    let workout: WorkoutDay
    let startDate = Date()
    private let historyRepository: WorkoutHistoryRepository

    init(workout: WorkoutDay, historyRepository: WorkoutHistoryRepository? = nil) {
        self.workout = workout
        if let historyRepository {
            self.historyRepository = historyRepository
        } else if #available(iOS 18.0, *) {
            self.historyRepository = GRPCHistoryRepository.shared
        } else {
            self.historyRepository = LocalHistoryRepository.shared
        }
    }

    func completeExercise(_ exercise: CompletedExercise) {
        guard currentExerciseIndex < workout.exercises.count else {
            return
        }
        completedExercises.append(exercise)
        currentExerciseIndex += 1;
    }

    func finish() -> WorkoutSession {
        let duration = Int(Date().timeIntervalSince(startDate) / 60)
        return WorkoutSession(
            workoutDayId: workout.id,
            completedExercises: completedExercises,
            duration: duration,
        )
    }

    func save() async {
        let session = finish()
        do {
            try await historyRepository.saveSession(session)
            await MainActor.run { self.saveError = nil }
        } catch {
            await MainActor.run { self.saveError = String(describing: error) }
            print("Failed to save session: \(error)")
        }
    }
}
