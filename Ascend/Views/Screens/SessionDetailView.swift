import SwiftUI

struct SessionDetailView: View {
    let session: WorkoutSession
    let workoutName: String?

    private var sets: [CompletedSet] { session.completedExercises.flatMap { $0.sets } }
    private var volume: Double { sets.reduce(0) { $0 + $1.weight * Double($1.reps) } }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    header
                    summary
                    exercisesList
                }
                .padding(Spacing.screenPadding)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(workoutName ?? "Session")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
            Text(session.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            if let duration = session.duration {
                Text("\(duration) min")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
            }
        }
    }

    private var summary: some View {
        HStack(spacing: Spacing.md) {
            summaryCard(value: "\(sets.count)", caption: "sets")
            summaryCard(value: "\(Int(volume))", caption: "volume kg")
            summaryCard(value: "\(session.completedExercises.count)", caption: "exercises")
        }
    }

    private func summaryCard(value: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(value)
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            Text(caption)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
    }

    private var exercisesList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            ForEach(session.completedExercises) { exercise in
                ExerciseBreakdown(exercise: exercise)
            }
        }
    }
}

private struct ExerciseBreakdown: View {
    let exercise: CompletedExercise

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(exercise.exerciseName)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.xs) {
                ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                    HStack {
                        Text("\(index + 1)")
                            .font(.labelMedium)
                            .foregroundColor(.textSecondary)
                            .frame(width: 24, alignment: .leading)
                        Text("\(set.weight.formatted()) kg × \(set.reps)")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        if let rpe = set.rpe {
                            Text("RPE \(rpe)")
                                .font(.labelMedium)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}
