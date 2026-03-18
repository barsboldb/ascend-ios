import SwiftUI

class ActiveWorkoutSession: ObservableObject {
    @Published var currentExerciseIndex: Int = 0
    private(set) var completedExercises: [CompletedExercise] = []
    let workout: WorkoutDay
    let startDate = Date()

    init(workout: WorkoutDay) {
        self.workout = workout
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
}
