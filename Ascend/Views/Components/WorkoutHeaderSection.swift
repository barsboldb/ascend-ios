import SwiftUI

struct WorkoutHeaderSection: View {
    let date: Date
    let week: Int

    var body: some View {
        HStack {
            Text("📅 \(date.formatted(.dateTime.weekday(.wide))) - Week \(week)")
                .font(.bodyLarge)
            Spacer()
        }
    }
}
