import SwiftUI

struct SessionProgress: View {
    let progress: CGFloat
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("SESSION PROGRESS")
                    .font(.labelLarge)
                    .foregroundColor(.primary)
                Text("\(Int(progress))% Complete")
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
            }
            Spacer()

            Circle()
                .stroke(Color.background, lineWidth: 8)
                .frame(width: Spacing.xxl, height: Spacing.xxl)
                .overlay(
                    Circle()
                        .trim(from: 0, to: 0.15)
                        .stroke(Color.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                )
        }
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}
