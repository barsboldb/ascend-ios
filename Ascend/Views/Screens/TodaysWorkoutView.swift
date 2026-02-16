import SwiftUI;

struct TodaysWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFinishLaterModal = false
    @State private var currentExerciseIndex = 0
    let workout: WorkoutDay
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

                    Text("\(workout.name) Day")
                        .foregroundColor(.textPrimary)
                        .font(.headlineLarge)

                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "dumbbell.fill")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        Text("\(workout.exercises.count) Exercises")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)

                        Text("·")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, Spacing.xs)

                        Image(systemName: "clock")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        Text("~\(workout.estimatedDuration) mins")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                    }
                    
                    SessionProgress(progress: 15)

                    ForEach(Array(workout.exercises.enumerated()), id: \.element.id) {index, exercise in
                        ExerciseCard(
                            exercise: exercise,
                            index: index + 1,
                            state: currentExerciseIndex == index ? .active : .upcoming,
                            previousWeight: nil,
                            onStart: {
                                if index == currentExerciseIndex {
                                    currentExerciseIndex += 1
                                }
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
        .navigationBarBackButtonHidden(true)
    }
}

