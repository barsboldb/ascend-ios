import SwiftUI

struct LastSessionCard: View {
    let session: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Last Session: \(timeAgo(from: session.date))")
            if let duration = session.duration {
                Text("Duration: \(duration) min")
            }
        }
        .font(.bodyMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(Spacing.radiusSmall)
    }

    private func timeAgo(from date: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return "\(days) days ago"
    }
}
