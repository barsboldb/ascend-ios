import SwiftUI

struct RestTimerSheet: View {
    let duration: Int
    @State private var remaining: Int
    @Environment(\.dismiss) private var dismiss

    init(duration: Int) {
        self.duration = duration
        self._remaining = State(initialValue: duration)
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text("REST")
                .font(.labelMedium)
                .foregroundColor(.textSecondary)

            ProgressRing(progress: getProgress(), lineWidth: 12, size: 220) {
                Text("\(formatRemaining(remaining))s")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                    .monospacedDigit()
            }

            Spacer()

            HStack(spacing: Spacing.sm) {
                AscendButton(
                    "+30s",
                    variant: .secondary,
                    fullWidth: true,
                    action: { remaining += 30 },
                )
                AscendButton(
                    "-10s",
                    variant: .secondary,
                    fullWidth: true,
                    action: { remaining -= 10 },
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
        .onAppear() {
            startTimer()
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
            if remaining > 0 {
                remaining -= 1
            } else {
                timer.invalidate()
                dismiss()
            }
        }
    }
}
