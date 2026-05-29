import SwiftUI

enum HomeRoute: Hashable {
    case history
    case profile
}

struct HomeView: View {
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var auth: AuthState
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

    private var firstName: String {
        let name = auth.currentUser?.name ?? ""
        let trimmed = name.split(separator: " ").first.map(String.init) ?? name
        return trimmed.isEmpty ? "friend" : trimmed
    }

    private var initial: String {
        firstName.prefix(1).uppercased()
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
                                Text("\(greeting), \(firstName)")
                                    .font(.headlineLarge)
                                    .foregroundColor(.textPrimary)

                                Spacer()

                                Button {
                                    navigation.navigate(to: HomeRoute.profile)
                                } label: {
                                    Circle()
                                        .fill(Color.accent)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Text(initial)
                                                .font(.titleLarge)
                                                .foregroundColor(.textPrimary)
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
                case .profile:
                    ProfileView()
                }
            }
            .navigationDestination(for: WorkoutSession.self) { session in
                SessionDetailView(
                    session: session,
                    workoutName: workoutManager.workoutName(for: session.workoutDayId),
                    onSessionChanged: { await workoutManager.refreshHistory() }
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
