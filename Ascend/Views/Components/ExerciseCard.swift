import SwiftUI

enum ExerciseCardState {
    case active
    case upcoming
    case completed
}

struct ExerciseCard: View {
    let exercise: Exercise
    let index: Int
    let state: ExerciseCardState
    let previousWeight: Double?
    let onStart: () -> Void

    var body: some View {
        Group {
            if state == .active {
                ActiveExerciseCard(
                    exercise: exercise,
                    previousWeight: previousWeight,
                    onStart: onStart,
                )
            } else {
                UpcomingExerciseCard(
                    exercise: exercise,
                    index: index,
                    previousWeight: previousWeight,
                    onStart: onStart,
                )
            }
        }
    }
}

struct ActiveExerciseCard: View {
    let exercise: Exercise
    let previousWeight: Double?
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: Spacing.radiusMedium) 
                        .fill(Color.primary)
                        .frame(width: 56, height: 56)
                    Image(systemName: "dumbbell.fill")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                }
                Text(exercise.name)
                    .foregroundColor(.textPrimary)
                    .font(.titleMedium)
            }
            HStack {
                Group {
                    VStack(spacing: Spacing.sm) {
                        Text("SETS")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.sets)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    VStack(spacing: Spacing.sm) {
                        Text("REPS")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.repRange.min)-\(exercise.repRange.max)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    VStack(spacing: Spacing.sm) {
                        Text("WEIGHT")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.targetWeight.formatted())kg")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.sm)
                .background(Color.background)
                .cornerRadius(Spacing.radiusSmall)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.radiusSmall)
                        .stroke(Color.textSecondary, lineWidth: 0.5)
                )
            }
            AscendButton(
                "Start Exercise",
                variant: .primary,
                size: .large,
                fullWidth: true,
                icon: "arrow.right",
                action: onStart
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusLarge)
                .stroke(Color.primary, lineWidth: 2)
        )
    }
}

struct UpcomingExerciseCard: View {
    let exercise: Exercise
    let index: Int
    let previousWeight: Double?
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                        .fill(Color.slate)
                        .frame(width: 56, height: 56)

                    Text("\(index)")
                        .font(.titleLarge)
                        .foregroundColor(.textSecondary)
                }
                Text(exercise.name)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
            }
            HStack {
                Group {
                    VStack(spacing: Spacing.sm) {
                        Text("SETS")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.sets)")
                            .font(.headlineSmall)
                            .foregroundColor(.textPrimary)
                    }
                    VStack(spacing: Spacing.sm) {
                        Text("REPS")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.repRange.min)-\(exercise.repRange.max)")
                            .font(.headlineSmall)
                            .foregroundColor(.textPrimary)
                    }
                    VStack(spacing: Spacing.sm) {
                        Text("WEIGHT")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)

                        Text("\(exercise.targetWeight.formatted())kg")
                            .font(.headlineSmall)
                            .foregroundColor(.textPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.sm)
                .background(Color.surface)
                .cornerRadius(Spacing.radiusSmall)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.radiusSmall)
                        .stroke(Color.textSecondary, lineWidth: 0.5)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}
