import ActivityKit
import SwiftUI
import UserNotifications

struct RestTimerSheet: View {
    let duration: Int
    let exerciseName: String
    @State private var startedAt: Date
    @State private var deadline: Date
    @State private var remaining: Int
    @State private var activity: Activity<RestTimerActivityAttributes>?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    init(duration: Int, exerciseName: String = "Workout") {
        self.duration = duration
        self.exerciseName = exerciseName
        let now = Date()
        self._startedAt = State(initialValue: now)
        self._deadline = State(initialValue: now.addingTimeInterval(TimeInterval(duration)))
        self._remaining = State(initialValue: duration)
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("REST")
                .font(.labelMedium)
                .foregroundColor(.textSecondary)

            ProgressRing(progress: getProgress(), lineWidth: 12, size: 220) {
                Text(formatRemaining(remaining))
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.snappy, value: remaining)
            }

            Spacer()

            HStack(spacing: Spacing.sm) {
                AscendButton(
                    "+30s",
                    variant: .secondary,
                    fullWidth: true,
                    action: { adjustDeadline(by: 30) },
                )
                AscendButton(
                    "-10s",
                    variant: .secondary,
                    fullWidth: true,
                    action: { adjustDeadline(by: -10) },
                )
            }
            AscendButton(
                "Skip",
                variant: .primary,
                size: .large,
                fullWidth: true,
                action: { dismiss() },
            )
        }
        .padding(Spacing.screenPadding)
        .presentationDetents([.large])
        .presentationBackground(Color.background)
        .onAppear {
            syncRemaining()
            startTimer()
            Task { await NotificationScheduler.shared.scheduleRestTimer(after: remaining) }
            startLiveActivity()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                syncRemaining()
            }
        }
        .onDisappear {
            Task { await NotificationScheduler.shared.cancelRestTimer() }
            endLiveActivity()
        }
    }

    private func adjustDeadline(by delta: Int) {
        deadline = deadline.addingTimeInterval(TimeInterval(delta))
        syncRemaining()
        Task { await NotificationScheduler.shared.scheduleRestTimer(after: remaining) }
        updateLiveActivity()
    }

    private func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = RestTimerActivityAttributes(exerciseName: exerciseName, totalDuration: duration)
        let state = RestTimerActivityAttributes.ContentState(deadline: deadline, startedAt: startedAt)
        do {
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: deadline.addingTimeInterval(60))
            )
        } catch {
            print("Live activity start failed: \(error)")
        }
    }

    private func updateLiveActivity() {
        guard let activity else { return }
        let state = RestTimerActivityAttributes.ContentState(deadline: deadline, startedAt: startedAt)
        Task {
            await activity.update(.init(state: state, staleDate: deadline.addingTimeInterval(60)))
        }
    }

    private func endLiveActivity() {
        guard let activity else { return }
        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        self.activity = nil
    }

    private func syncRemaining() {
        let newRemaining = max(0, Int(deadline.timeIntervalSinceNow.rounded(.up)))
        remaining = newRemaining
        if newRemaining == 0 {
            dismiss()
        }
    }

    private func getProgress() -> Double {
        return Double(remaining) / Double(duration)
    }

    private func formatRemaining(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            syncRemaining()
            if remaining == 0 {
                timer.invalidate()
            }
        }
    }
}
