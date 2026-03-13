import SwiftUI

struct SessionProgress: View {
    let progress: CGFloat
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("SESSION PROGRESS")
                    .font(.labelLarge)
                    .foregroundColor(.primary)
                Text("\(Int(progress * 100))% Complete")
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
            }
            Spacer()

            ProgressRing(progress: progress, lineWidth: 8, size: 48, trackColor: .background)
        }
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}
