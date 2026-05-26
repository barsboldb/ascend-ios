struct ExerciseTarget {
    let weight: Double
    let repRange: RepRange
    let weightDelta: Double

    var hasProgression: Bool { weightDelta > 0 }
}

struct ProgressionService {
    func calculateTarget(for exercise: Exercise, history: [CompletedExercise]) -> ExerciseTarget {
        guard let last = history.last, !last.sets.isEmpty else {
            return ExerciseTarget(weight: exercise.targetWeight, repRange: exercise.repRange, weightDelta: 0)
        }

        let lastWeight = last.sets.map { $0.weight }.max() ?? exercise.targetWeight

        // Bodyweight and hold exercises: no weight progression
        guard exercise.type == .reps, lastWeight > 0 else {
            return ExerciseTarget(weight: lastWeight, repRange: exercise.repRange, weightDelta: 0)
        }

        let allHitMax = last.sets.allSatisfy { $0.reps >= exercise.repRange.max }
        if allHitMax {
            let increment = exercise.tag.increment
            return ExerciseTarget(weight: lastWeight + increment, repRange: exercise.repRange, weightDelta: increment)
        }

        return ExerciseTarget(weight: lastWeight, repRange: exercise.repRange, weightDelta: 0)
    }
}
