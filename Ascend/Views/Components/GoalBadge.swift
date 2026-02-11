import SwiftUI

struct GoalBadge: View {
    let goalText: String

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.labelMedium)

            Text(goalText.uppercased())
                .font(.labelMedium)
                .tracking(0.5)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(
            Color.primary.opacity(0.15)
        )
        .cornerRadius(Spacing.radiusFull)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusFull)
                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
        )
    }
}
