import SwiftUI

class ActiveWorkoutSession: ObservableObject {
    @Published var currentExerciseIndex: Int = 0
    private(set) var completedExercises: [CompletedExercise] = []
    let workout: WorkoutDay

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
}
