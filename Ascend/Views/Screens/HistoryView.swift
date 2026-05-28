import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var navigation: NavigationState
    @ObservedObject var workoutManager: WorkoutManager
    @State private var selectedMetric: ChartMetric = .totalVolume

    private var sessions: [WorkoutSession] {
        workoutManager.workoutHistory.sorted { $0.date > $1.date }
    }

    private var exerciseOptions: [String] {
        let counts = Dictionary(grouping: sessions.flatMap { $0.completedExercises }) { $0.exerciseName }
            .mapValues { $0.count }
        return counts.keys.sorted { (counts[$0] ?? 0) > (counts[$1] ?? 0) }
    }

    private var metricOptions: [ChartMetric] {
        [.totalVolume] + exerciseOptions.map { .exercise($0) }
    }

    private var progressionSeries: [ProgressPoint] {
        switch selectedMetric {
        case .totalVolume:
            return sessions
                .sorted { $0.date < $1.date }
                .map { session in
                    let volume = session.completedExercises
                        .flatMap { $0.sets }
                        .reduce(0.0) { $0 + $1.weight * Double($1.reps) }
                    return ProgressPoint(date: session.date, value: volume)
                }
        case .exercise(let name):
            return sessions
                .sorted { $0.date < $1.date }
                .compactMap { session -> ProgressPoint? in
                    guard let match = session.completedExercises.first(where: { $0.exerciseName == name }),
                          let topSet = match.sets.max(by: { $0.weight < $1.weight }),
                          topSet.weight > 0 else { return nil }
                    return ProgressPoint(date: session.date, value: topSet.weight)
                }
        }
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            if sessions.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("History")
                            .font(.headlineLarge)
                            .foregroundColor(.textPrimary)

                        if !sessions.isEmpty {
                            ProgressionChart(
                                metricOptions: metricOptions,
                                selectedMetric: $selectedMetric,
                                points: progressionSeries
                            )
                        }

                        ForEach(sessions) { session in
                            Button {
                                navigation.navigate(to: session)
                            } label: {
                                HistoryRow(
                                    session: session,
                                    workoutName: workoutManager.workoutName(for: session.workoutDayId)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(Spacing.screenPadding)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)
            Text("No workouts yet")
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            Text("Finish your first workout to see it here.")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.screenPadding)
    }
}

private struct HistoryRow: View {
    let session: WorkoutSession
    let workoutName: String?

    private var sets: [CompletedSet] { session.completedExercises.flatMap { $0.sets } }
    private var volume: Double { sets.reduce(0) { $0 + $1.weight * Double($1.reps) } }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(workoutName ?? "Workout")
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(session.date.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
            }

            HStack(spacing: Spacing.md) {
                statItem(value: "\(sets.count)", caption: "sets")
                statItem(value: "\(Int(volume))", caption: "kg")
                if let duration = session.duration {
                    statItem(value: "\(duration)", caption: "min")
                }
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }

    private func statItem(value: String, caption: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            Text(value)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            Text(caption)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
        }
    }
}

struct ProgressPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

enum ChartMetric: Hashable {
    case totalVolume
    case exercise(String)

    var displayName: String {
        switch self {
        case .totalVolume: return "Total Volume"
        case .exercise(let name): return name
        }
    }

    var unit: String {
        switch self {
        case .totalVolume: return "kg"
        case .exercise: return "kg"
        }
    }

    var emptyMessage: String {
        switch self {
        case .totalVolume: return "No sessions yet"
        case .exercise: return "No history yet for this exercise"
        }
    }
}

private struct ProgressionChart: View {
    let metricOptions: [ChartMetric]
    @Binding var selectedMetric: ChartMetric
    let points: [ProgressPoint]

    private var trendLabel: String {
        guard let first = points.first?.value, let last = points.last?.value, first > 0 else {
            return points.isEmpty ? "no data yet" : "\(points.count) session\(points.count == 1 ? "" : "s")"
        }
        switch selectedMetric {
        case .totalVolume:
            let pct = ((last - first) / first) * 100
            let sign = pct >= 0 ? "+" : ""
            return "\(sign)\(String(format: "%.0f", pct))% · \(points.count) sessions"
        case .exercise:
            let delta = last - first
            let sign = delta >= 0 ? "+" : ""
            return "\(sign)\(String(format: "%.1f", delta))kg · \(points.count) sessions"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Menu {
                    ForEach(metricOptions, id: \.self) { metric in
                        Button(metric.displayName) { selectedMetric = metric }
                    }
                } label: {
                    HStack(spacing: Spacing.xs) {
                        Text(selectedMetric.displayName)
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        Image(systemName: "chevron.down")
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                    }
                }
                Spacer()
                Text(trendLabel)
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
            }

            if points.isEmpty {
                Text(selectedMetric.emptyMessage)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 160)
            } else {
                chart
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }

    private var chart: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value(selectedMetric.unit, point.value)
            )
            .foregroundStyle(Color.primary)
            .interpolationMethod(.catmullRom)

            AreaMark(
                x: .value("Date", point.date),
                y: .value(selectedMetric.unit, point.value)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.primary.opacity(0.3), Color.primary.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Date", point.date),
                y: .value(selectedMetric.unit, point.value)
            )
            .foregroundStyle(Color.primary)
            .symbolSize(20)
        }
        .frame(height: 160)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                AxisGridLine().foregroundStyle(Color.textSecondary.opacity(0.2))
                AxisValueLabel().foregroundStyle(Color.textSecondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine().foregroundStyle(Color.textSecondary.opacity(0.2))
                AxisValueLabel().foregroundStyle(Color.textSecondary)
            }
        }
    }
}
