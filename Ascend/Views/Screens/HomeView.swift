import SwiftUI

enum HomeRoute: Hashable {
    case history
}

struct HomeView: View {
    @EnvironmentObject var navigation: NavigationState
    @StateObject private var workoutManager = WorkoutManager()
    @State private var selectedWorkout: WorkoutDay?
    @State private var goalText: String? = nil

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }

    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                Color.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text(dateString)
                                .font(.labelMedium)
                                .foregroundColor(.textSecondary)
                                .tracking(1)

                            HStack(alignment: .top) {
                                Text("\(greeting), Alex")
                                    .font(.headlineLarge)
                                    .foregroundColor(.textPrimary)

                                Spacer()

                                Button {
                                    // Profile action
                                } label: {
                                    Circle()
                                        .fill(Color.accent)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Text("A")
                                                .font(.titleLarge)
                                                .foregroundColor(.textPrimary)
                                        )
                                        .overlay(
                                            Circle()
                                                .fill(Color.success)
                                                .frame(width: 12, height: 12)
                                                .offset(x: 12, y: 12)
                                        )
                                }
                            }
                        }

                        if let todaysWorkout = workoutManager.getTodaysWorkout() {

                            if let goal = goalText {
                                GoalBadge(goalText: "Goal: \(goal)")
                            }

                            WorkoutCard(
                                workout: todaysWorkout,
                                week: workoutManager.getCurrentWeek(),
                                day: workoutManager.getCurrentDayNumber(),
                                onStart: {
                                    navigation.navigate(to: todaysWorkout)
                                }
                            )
                        }

                        ActivityCalendar(sessions: workoutManager.workoutHistory) {
                            navigation.navigate(to: HomeRoute.history)
                        }
                    }
                    .padding(Spacing.screenPadding)
                }
            }
            .navigationDestination(for: WorkoutDay.self) { workout in
                WorkoutSessionContainer(workout: workout)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .history:
                    HistoryView(workoutManager: workoutManager)
                }
            }
            .navigationDestination(for: WorkoutSession.self) { session in
                SessionDetailView(
                    session: session,
                    workoutName: workoutManager.workoutName(for: session.workoutDayId)
                )
            }
            .task {
                await workoutManager.loadData()
                if let workout = workoutManager.getTodaysWorkout() {
                    goalText = await workoutManager.goalText(for: workout)
                }
            }
        }
    }
}
