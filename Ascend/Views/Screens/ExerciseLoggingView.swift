import SwiftUI

struct ExerciseLoggingView: View {
    @EnvironmentObject() private var navigation: NavigationState
    @State private var showRestTimer = false
    @State private var previousExercise: CompletedExercise? = nil
    @State private var weight: Double = 50.0
    @State private var reps: Int = 6
    @State private var rpe: Int = 0

    let workoutName: String
    let exercise: Exercise


    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .center, spacing: Spacing.md) {
                            Text("\(exercise.name)")
                                .font(.headlineMedium)
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: geometry.size.width * 0.7, alignment: .center)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)

                            SetPill(sets: [])

                            HStack(alignment: .center, spacing: Spacing.md) {
                                PreviousCard(previousExercise: previousExercise)
                                TargetCard()
                            }
                            .frame(maxWidth: .infinity)

                            SetLoggingCard(
                                setNumber: 1, 
                                totalSets: 4, 
                                weightIncrement: 2.5, 
                                weight: $weight, 
                                reps: $reps,
                                rpe: $rpe,
                                onLog: {}
                            )

                            Button("Dismiss") {
                                navigation.goBack()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                AscendButton(
                    "Complete Set",
                    variant: .primary,
                    size: .large,
                    fullWidth: true,
                    icon: "clock",
                ) {
                    showRestTimer = true
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
        .sheet(isPresented: $showRestTimer) {
            RestTimerSheet(duration: 240)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            previousExercise = try? await LocalHistoryRepository.shared.getLastPerformedExercise(named: exercise.name)
        }
    }
}

struct PreviousCard: View {
    let previousExercise: CompletedExercise?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("PREVIOUS")
                .font(.labelMedium)
                .foregroundColor(.textSecondary)

            if let previousExercise = previousExercise {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.sm) {
                        Group {
                            Text("\(previousExercise.sets[0].weight.formatted())kg")
                            Text("×")
                                .font(.labelSmall)
                                .foregroundColor(.textSecondary)
                            Text("\(previousExercise.sets[0].reps)")
                        }
                        .font(.labelLarge)
                        .foregroundColor(.textPrimary)
                    }
                    if let rpe = previousExercise.sets[0].rpe {
                        Text("RPE \(rpe)")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
    }
}

struct TargetCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .center, spacing: Spacing.xs) {
                Image(systemName: "chevron.compact.up")
                    .font(.labelMedium)
                    .foregroundColor(.success)
                Text("TARGET")
                    .font(.labelMedium)
                    .foregroundColor(.success)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: Spacing.sm) {
                    Text("75.5kg")
                        .font(.labelLarge)
                        .foregroundColor(.textPrimary)
                    Text("+2.5kg")
                        .font(.labelMedium)
                        .foregroundColor(.success)
                }

                Text("or +1 rep")
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                .stroke(Color.success, style: StrokeStyle(lineWidth: 1))
        )
    }
}
