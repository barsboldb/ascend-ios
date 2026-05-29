import SwiftUI

struct ExerciseLoggingView: View {
    @EnvironmentObject() private var navigation: NavigationState
    @EnvironmentObject() private var session: ActiveWorkoutSession
    @State private var isExerciseComplete = false
    @State private var showRestTimer = false
    @State private var previousExercise: CompletedExercise? = nil
    @State private var target: ExerciseTarget? = nil
    @State private var weight: Double = 50.0
    @State private var reps: Int = 6
    @State private var rpe: Int = 0
    @State private var activeSetIndex: Int = 0
    @State private var sets: [SetLog] = []

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

                            SetPill(sets: $sets)

                            HStack(alignment: .top, spacing: Spacing.md) {
                                PreviousCard(previousExercise: previousExercise)
                                TargetCard(target: target, exercise: exercise)
                            }
                            .frame(maxWidth: .infinity)
                            .fixedSize(horizontal: false, vertical: true)

                            SetLoggingCard(
                                setNumber: activeSetIndex + 1, 
                                totalSets: sets.count, 
                                weightIncrement: 2.5, 
                                weight: $weight, 
                                reps: $reps,
                                rpe: $rpe,
                            )
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
                    completeSet()
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
        .sheet(isPresented: $showRestTimer, onDismiss: advanceSet) {
            RestTimerSheet(duration: session.workout.exercises[session.currentExerciseIndex].restSeconds)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            if #available(iOS 18.0, *) {
                previousExercise = try? await GRPCHistoryRepository.shared.getLastPerformedExercise(exerciseId: exercise.id)
            } else {
                previousExercise = try? await LocalHistoryRepository.shared.getLastPerformedExercise(named: exercise.name)
            }
            let history = [previousExercise].compactMap { $0 }
            target = ProgressionService().calculateTarget(for: exercise, history: history)
            if let lastSet = previousExercise?.sets.first {
                weight = lastSet.weight
                reps = lastSet.reps
                rpe = lastSet.rpe ?? 7
            } else {
                weight = exercise.targetWeight
                reps = exercise.repRange.min
                rpe = 7
            }

            sets = (0..<exercise.sets).map { i in 
                SetLog(
                    id: UUID(),
                    targetWeight: weight,
                    targetRepRange: "\(exercise.repRange.min)-\(exercise.repRange.max)",
                    status: i == 0 ? .active : .pending
                )
            }
        }
    }

    private func completeSet() {
        guard activeSetIndex < sets.count else { return }
        sets[activeSetIndex].loggedWeight = weight
        sets[activeSetIndex].loggedReps = reps
        sets[activeSetIndex].rpe = rpe
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            sets[activeSetIndex].status = .completed
        }
        showRestTimer = true
    }

    private func advanceSet() {
        guard !isExerciseComplete else { return }
        guard activeSetIndex + 1 < sets.count else {
            isExerciseComplete = true
            saveSession()
            navigation.goBack()
            return
        }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            activeSetIndex += 1
            sets[activeSetIndex].status = .active
        }
    }

    private func saveSession() {
        let completedSets = sets.compactMap { set -> CompletedSet? in 
            guard let weight = set.loggedWeight, let reps = set.loggedReps else { return nil }
            return CompletedSet(
                reps: reps, 
                weight: weight, 
                rpe: set.rpe, 
                completed: true, 
                notes: "",
            )
        }

        let completedExercise = CompletedExercise(
            exerciseId: exercise.id,
            exerciseName: exercise.name,
            sets: completedSets,
        )

        session.completeExercise(completedExercise)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
    }
}

struct TargetCard: View {
    let target: ExerciseTarget?
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(alignment: .center, spacing: Spacing.xs) {
                if target?.hasProgression == true {
                    Image(systemName: "chevron.compact.up")
                        .font(.labelMedium)
                        .foregroundColor(.success)
                }
                Text("TARGET")
                    .font(.labelMedium)
                    .foregroundColor(target?.hasProgression == true ? .success : .textSecondary)
            }

            if let target {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    HStack(spacing: Spacing.sm) {
                        Text(exercise.type == .amrap ? "AMRAP" : "\(target.weight.formatted())kg")
                            .font(.labelLarge)
                            .foregroundColor(.textPrimary)
                        if target.weightDelta > 0 {
                            Text("+\(target.weightDelta.formatted())kg")
                                .font(.labelMedium)
                                .foregroundColor(.success)
                        }
                    }

                    if exercise.type == .reps {
                        if target.hasProgression {
                            Text("or +1 rep at \((target.weight - target.weightDelta).formatted())kg")
                                .font(.labelSmall)
                                .foregroundColor(.textSecondary)
                        } else {
                            Text("\(target.repRange.min)–\(target.repRange.max) reps")
                                .font(.labelSmall)
                                .foregroundColor(.textSecondary)
                        }
                    } else if exercise.type == .hold {
                        Text("\(target.repRange.min)–\(target.repRange.max)s")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                .stroke(target?.hasProgression == true ? Color.success : Color.clear, style: StrokeStyle(lineWidth: 1))
        )
    }
}
