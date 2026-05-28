import SwiftUI

struct WorkoutCompleteView: View {
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var session: ActiveWorkoutSession
    @State private var saveStatus: SaveStatus = .saving

    enum SaveStatus {
        case saving, saved, failed(String)
    }

    @State private var dayStreak: Int = 0

    private var allSets: [CompletedSet] {
        session.completedExercises.flatMap { $0.sets }
    }

    private var totalSets: Int { allSets.count }

    private var totalReps: Int {
        allSets.reduce(0) { $0 + $1.reps }
    }

    private var totalVolume: Double {
        allSets.reduce(0) { $0 + $1.weight * Double($1.reps) }
    }

    private var avgRPE: Double? {
        let rpes = allSets.compactMap { $0.rpe }
        guard !rpes.isEmpty else { return nil }
        return Double(rpes.reduce(0, +)) / Double(rpes.count)
    }

    private var nextUpLabel: String {
        switch session.workout.type {
        case .push: return "pull day · tomorrow"
        case .pull: return "leg day · tomorrow"
        case .legs: return "push day · tomorrow"
        }
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                streakHero
                statsGrid
                nextUpAndStatus

                Spacer()

                actionBar
            }
            .padding(.horizontal, Spacing.screenPadding)
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.lg)
        }
        .task {
            await session.save()
            saveStatus = session.saveError.map(SaveStatus.failed) ?? .saved

            if #available(iOS 18.0, *),
               let recent = try? await GRPCHistoryRepository.shared.getRecentSessions(limit: 60) {
                dayStreak = WorkoutManager.calculateStreak(from: recent)
            }
        }
    }

    private var streakHero: some View {
        VStack(spacing: Spacing.xs) {
            Text("\(dayStreak)")
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(.primary)

            HStack(spacing: Spacing.xs) {
                Text("day streak")
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                Text("🔥")
                    .font(.headlineSmall)
            }

            Text(streakSubtitle)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
    }

    private var streakSubtitle: String {
        switch dayStreak {
        case 0: return "ready when you are"
        case 1: return "first one — keep going"
        default: return "keep it up"
        }
    }

    private var statsGrid: some View {
        VStack(spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                StatCard(value: "\(totalSets)", caption: "sets")
                StatCard(value: "\(totalReps)", caption: "total reps")
            }
            HStack(spacing: Spacing.md) {
                StatCard(value: formattedVolume, caption: "volume kg")
                StatCard(value: formattedRPE, caption: "avg RPE")
            }
        }
    }

    private var formattedVolume: String {
        totalVolume.formatted(.number.precision(.fractionLength(0)))
    }

    private var formattedRPE: String {
        guard let avg = avgRPE else { return "—" }
        return String(format: "%.1f", avg)
    }

    private var nextUpAndStatus: some View {
        VStack(spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Text("next up:")
                    .foregroundColor(.textSecondary)
                Text(nextUpLabel)
                    .foregroundColor(.textPrimary)
            }
            .font(.bodyMedium)

            saveStatusRow
        }
    }

    @ViewBuilder
    private var saveStatusRow: some View {
        switch saveStatus {
        case .saving:
            HStack(spacing: Spacing.xs) {
                ProgressView().scaleEffect(0.7)
                Text("saving…")
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
            }
        case .saved:
            HStack(spacing: Spacing.xs) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
                Text("saved")
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
            }
        case .failed(let message):
            VStack(spacing: 2) {
                Text("save failed")
                    .font(.labelSmall)
                    .foregroundColor(.error)
                Text(message)
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }

    private var actionBar: some View {
        HStack(spacing: Spacing.sm) {
            AscendButton("Finish ✓", size: .large, fullWidth: true) {
                navigation.goHome()
            }

            Button {
                // TODO: share session summary
            } label: {
                Image(systemName: "arrow.up.right")
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                    .frame(width: 52, height: 52)
                    .background(Color.surface)
                    .cornerRadius(Spacing.radiusLarge)
            }
        }
    }
}

private struct StatCard: View {
    let value: String
    let caption: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.textPrimary)
            Text(caption)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardPadding)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}
