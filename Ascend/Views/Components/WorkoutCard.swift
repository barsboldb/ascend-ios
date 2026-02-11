import SwiftUI

struct WorkoutCard: View {
    let workout: WorkoutDay
    let week: Int
    let day: Int
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("WEEK \(week) · DAY \(day)")
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                        .tracking(1)

                    Text(workout.name)
                        .font(.displaySmall)
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("EST.")
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                    Text("DURATION")
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                    Text("\(workout.estimatedDuration)")
                        .font(.headlineSmall)
                        .foregroundColor(.textPrimary)
                    + Text(" min")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
            }

            MuscleGroupTags(workoutType: workout.type)

            Spacer()

            VStack(spacing: Spacing.sm) {
                ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                    ExercisePreviewRow(
                        index: index + 1,
                        exercise: exercise
                    )
                }
            }

            AscendButton(
                "START WORKOUT",
                variant: .primary,
                size: .large,
                fullWidth: true,
                icon: "play.fill",
                action: onStart
            )
        }
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}

struct ExercisePreviewRow: View {
    let index: Int
    let exercise: Exercise

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Text(String(format: "%02d", index))
                .font(.labelLarge)
                .foregroundColor(.primary)
                .frame(width: 28, alignment: .leading)
                .padding(.top, 2)

            Text(exercise.name)
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Text("\(exercise.sets) × \(exercise.repRange)")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .padding(.top, 2)
        }
        .frame(height: 44, alignment: .top)
    }
}

struct MuscleGroupTags: View {
    let workoutType: WorkoutType

    var muscleGroups: [String] {
        switch workoutType {
        case .push:
            return ["Chest", "Triceps", "Front Delts"]
        case .pull:
            return ["Back", "Biceps", "Rear Delts"]
        case .legs:
            return ["Quads", "Hamstrings", "Glutes", "Core"]
        }
    }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(muscleGroups, id: \.self) { group in
                Text(group)
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(Color.background)
                    .cornerRadius(Spacing.radiusSmall)
            }
        }
    }
}
