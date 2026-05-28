import SwiftUI;

struct TodaysWorkoutView: View {
    @EnvironmentObject() var navigation: NavigationState 
    @EnvironmentObject() var session: ActiveWorkoutSession
    @Environment(\.dismiss) private var dismiss
    @State private var showFinishLaterModal = false
    @State private var showCompletion = false

    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    HStack {
                        Text("Week 4 / Day 2")
                            .foregroundColor(.primary)
                            .font(.labelLarge)

                        Spacer()

                        Button {
                            showFinishLaterModal = true
                        } label: {
                            Text("Finish Later")
                                .foregroundColor(.textSecondary)
                                .font(.labelMedium)
                        }
                    }

                    Text("\(session.workout.name) Day")
                        .foregroundColor(.textPrimary)
                        .font(.headlineLarge)

                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "dumbbell.fill")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        Text("\(session.workout.exercises.count) Exercises")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)

                        Text("·")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, Spacing.xs)

                        Image(systemName: "clock")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        Text("~\(session.workout.estimatedDuration) mins")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    SessionProgress(
                        progress: (Double(session.currentExerciseIndex) / Double(session.workout.exercises.count)),
                    )

                    ForEach(Array(session.workout.exercises.enumerated()), id: \.element.id) {index, exercise in
                        ExerciseCard(
                            exercise: exercise,
                            index: index + 1,
                            state: session.currentExerciseIndex == index ? .active : .upcoming,
                            previousWeight: nil,
                            onStart: {
                                navigation.navigate(to: session.workout.exercises[session.currentExerciseIndex])
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.screenPadding)
            }
            if showFinishLaterModal {
                ConfirmationModal(
                    title: "Finish Later?",
                    message: "You progress will be saved and you can continue this workout anytime.",
                    confirmText: "Finish Later",
                    cancelText: "Continue Workout",
                    confirmDestructive: true,
                    onConfirm: {
                        showFinishLaterModal = false
                        dismiss()
                    },
                    onCancel: {
                        showFinishLaterModal = false
                    }
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: showFinishLaterModal)
            }
        }
        .onChange(of: session.currentExerciseIndex) { _, newIndex in
            if newIndex >= session.workout.exercises.count {
                showCompletion = true
                Task { await session.save() }
            }
        }
        .fullScreenCover(isPresented: $showCompletion) {
            WorkoutCompleteView()
                .environmentObject(session)
                .environmentObject(navigation)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: Exercise.self) {exercise in
            ExerciseLoggingView(exercise: exercise)
                .environmentObject(session)
        }
    }
}

