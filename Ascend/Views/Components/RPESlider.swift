import SwiftUI

struct RPESlider: View {
    @Binding var rpe: Int

    private let labels = ["Easy", "Moderate", "Hard", "Failure"]
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("RPE (EXERTION)")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(rpe.formatted())
                    .font(.titleMedium)
                    .foregroundColor(.primary)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(rpe)))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: rpe)
            }

            Slider(value: Binding(
                get: { Double(rpe) },
                set: { rpe = Int($0) },
            ), in: 1...10, step: 0.5)
            .tint(Color.primary)

            HStack {
                ForEach(labels, id: \.self) { label in
                    Text(label)
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                    if label != labels.last {
                        Spacer()
                    }
                }
            }
        }
    }
}
