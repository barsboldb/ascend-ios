import SwiftUI

struct ConsistencySection: View {
    let workoutHistory: [WorkoutSession]

    private var currentStreak: Int {
        calculateStreak()
    }

    private var activityGrid: [[Bool]] {
        generateActivityGrid()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Consistency")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)

                Spacer()

                HStack(spacing: Spacing.xs) {
                    Text("\(currentStreak)")
                        .font(.titleLarge)
                        .foregroundColor(.success)
                    Text("day streak")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
            }

            ActivityGrid(activityDays: activityGrid)
        }
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }

    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let sortedSessions = workoutHistory
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)

        guard let mostRecent = sortedSessions.first else { return 0 }

        let daysBetween = calendar.dateComponents([.day], from: mostRecent, to: today).day ?? 0
        if daysBetween > 1 { return 0 }

        var streak = 0
        var currentDate = mostRecent

        for sessionDate in sortedSessions {
            if sessionDate == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if sessionDate < currentDate {
                let dayDiff = calendar.dateComponents([.day], from: sessionDate, to: currentDate).day ?? 0
                if dayDiff > 1 { break }
                currentDate = sessionDate
            }
        }

        return streak
    }

    private func generateActivityGrid() -> [[Bool]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let workoutDates = Set(workoutHistory.map { calendar.startOfDay(for: $0.date) })

        var grid: [[Bool]] = []
        let rows = 5
        let cols = 8

        for row in 0..<rows {
            var rowData: [Bool] = []
            for col in 0..<cols {
                let daysBack = (cols - 1 - col) * rows + (rows - 1 - row)
                if let date = calendar.date(byAdding: .day, value: -daysBack, to: today) {
                    rowData.append(workoutDates.contains(date))
                } else {
                    rowData.append(false)
                }
            }
            grid.append(rowData)
        }

        return grid
    }
}

struct ActivityGrid: View {
    let activityDays: [[Bool]]

    var body: some View {
        VStack(spacing: Spacing.xs) {
            ForEach(0..<activityDays.count, id: \.self) { row in
                HStack(spacing: Spacing.xs) {
                    ForEach(0..<activityDays[row].count, id: \.self) { col in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(activityDays[row][col] ? Color.success : Color.midnight.opacity(0.4))
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
    }
}
