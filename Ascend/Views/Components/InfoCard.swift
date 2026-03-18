import SwiftUI

struct InfoCard: View {
    let title: String
    let info: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .foregroundColor(.textSecondary)
                .font(.labelSmall)
            HStack {
                Text(info)
                    .font(.headlineMedium)
                    .foregroundColor(.textPrimary)
            }
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
    }
}
