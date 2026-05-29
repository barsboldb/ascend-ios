import ActivityKit
import SwiftUI
import WidgetKit

struct RestTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RestTimerActivityAttributes.self) { context in
            LockScreenView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.6))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                        .foregroundStyle(.purple)
                        .font(.title2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: Date()...context.state.deadline, countsDown: true)
                        .monospacedDigit()
                        .font(.title2.bold())
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.exerciseName)
                            .font(.headline)
                            .foregroundStyle(.white)
                        ProgressView(timerInterval: context.state.startedAt...context.state.deadline, countsDown: false)
                            .tint(.purple)
                    }
                }
            } compactLeading: {
                Image(systemName: "timer").foregroundStyle(.purple)
            } compactTrailing: {
                Text(timerInterval: Date()...context.state.deadline, countsDown: true)
                    .monospacedDigit()
                    .frame(maxWidth: 50)
            } minimal: {
                Image(systemName: "timer").foregroundStyle(.purple)
            }
        }
    }
}

private struct LockScreenView: View {
    let context: ActivityViewContext<RestTimerActivityAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Rest", systemImage: "timer")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text(context.attributes.exerciseName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }

            Text(timerInterval: Date()...context.state.deadline, countsDown: true)
                .font(.system(size: 48, weight: .bold).monospacedDigit())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)

            ProgressView(timerInterval: context.state.startedAt...context.state.deadline, countsDown: false)
                .tint(.purple)
        }
        .padding()
    }
}
