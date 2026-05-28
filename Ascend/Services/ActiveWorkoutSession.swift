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
        print("[Ascend] save() called: dayId=\(session.workoutDayId.uuidString), exercises=\(session.completedExercises.count)")
        for ex in session.completedExercises {
            print("[Ascend]   exercise: name=\(ex.exerciseName), id=\(ex.exerciseId?.uuidString ?? "nil"), sets=\(ex.sets.count)")
        }
        do {
            try await historyRepository.saveSession(session)
            print("[Ascend] save() succeeded")
            await MainActor.run { self.saveError = nil }
        } catch {
            print("[Ascend] save() FAILED: \(error)")
            await MainActor.run { self.saveError = String(describing: error) }
        }
    }
}
