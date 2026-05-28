import SwiftUI

struct ActivityCalendar: View {
    let sessions: [WorkoutSession]
    let weeksToShow: Int
    let onTap: () -> Void

    init(sessions: [WorkoutSession], weeksToShow: Int = 17, onTap: @escaping () -> Void) {
        self.sessions = sessions
        self.weeksToShow = weeksToShow
        self.onTap = onTap
    }

    private var calendar: Calendar { Calendar.current }

    private var volumeByDay: [Date: Double] {
        var result: [Date: Double] = [:]
        for session in sessions {
            let day = calendar.startOfDay(for: session.date)
            let volume = session.completedExercises
                .flatMap { $0.sets }
                .reduce(0.0) { $0 + $1.weight * Double($1.reps) }
            result[day, default: 0] += volume
        }
        return result
    }

    private var maxVolume: Double {
        volumeByDay.values.max() ?? 1
    }

    private var weeks: [[Date]] {
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysSinceWeekStart = (weekday - calendar.firstWeekday + 7) % 7
        guard let thisWeekStart = calendar.date(byAdding: .day, value: -daysSinceWeekStart, to: today),
              let startDate = calendar.date(byAdding: .day, value: -(weeksToShow - 1) * 7, to: thisWeekStart)
        else { return [] }

        var result: [[Date]] = []
        for week in 0..<weeksToShow {
            var weekDays: [Date] = []
            for day in 0..<7 {
                if let d = calendar.date(byAdding: .day, value: week * 7 + day, to: startDate) {
                    weekDays.append(d)
                }
            }
            result.append(weekDays)
        }
        return result
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                HStack {
                    Text("Activity")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.labelMedium)
                        .foregroundColor(.textSecondary)
                }

                HStack {
                    Grid(horizontalSpacing: 3, verticalSpacing: 3) {
                        ForEach(0..<7, id: \.self) { dayIdx in
                            GridRow {
                                ForEach(weeks.indices, id: \.self) { weekIdx in
                                    Rectangle()
                                        .fill(colorFor(date: weeks[weekIdx][dayIdx]))
                                        .frame(width: 16, height: 16)
                                        .cornerRadius(2)
                                }
                            }
                        }
                    }
                    Spacer(minLength: 0)
                }

                HStack(spacing: Spacing.xs) {
                    Text("Less")
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                    ForEach(0..<5, id: \.self) { level in
                        Rectangle()
                            .fill(legendColor(level: level))
                            .frame(width: 10, height: 10)
                            .cornerRadius(2)
                    }
                    Text("More")
                        .font(.labelSmall)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(Spacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .cornerRadius(Spacing.radiusLarge)
        }
        .buttonStyle(.plain)
    }

    private func colorFor(date: Date) -> Color {
        let today = calendar.startOfDay(for: Date())
        if date > today { return Color.textSecondary.opacity(0.05) }
        let volume = volumeByDay[date] ?? 0
        if volume == 0 { return Color.textSecondary.opacity(0.15) }
        let ratio = min(volume / maxVolume, 1.0)
        return Color.primary.opacity(0.25 + ratio * 0.75)
    }

    private func legendColor(level: Int) -> Color {
        if level == 0 { return Color.textSecondary.opacity(0.15) }
        let ratio = Double(level) / 4
        return Color.primary.opacity(0.25 + ratio * 0.75)
    }
}
