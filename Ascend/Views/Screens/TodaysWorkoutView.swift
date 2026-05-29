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
        }
        .alert("Finish Later?", isPresented: $showFinishLaterModal) {
            Button("Finish Later", role: .destructive) { dismiss() }
            Button("Continue Workout", role: .cancel) {}
        } message: {
            Text("Your progress will be saved and you can continue this workout anytime.")
        }
        .onChange(of: session.currentExerciseIndex) { _, newIndex in
            if newIndex >= session.workout.exercises.count {
                showCompletion = true
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

