struct ExerciseTarget {
    let weight: Double
    let repRange: RepRange
}

struct ProgressionService {
    func calculateTarget(for exercise: Exercise, history: [CompletedExercise]) -> ExerciseTarget {
        if history.count == 0 {
            return ExerciseTarget(weight: exercise.targetWeight, repRange: exercise.repRange)
        }
        return ExerciseTarget(weight: 0, repRange: RepRange(min: 0, max: 0))
    }
}
