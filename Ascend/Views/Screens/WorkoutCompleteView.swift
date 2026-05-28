import SwiftUI

struct WorkoutCompleteView: View {
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var session: ActiveWorkoutSession
    @State private var saveStatus: SaveStatus = .saving

    enum SaveStatus {
        case saving
        case saved
        case failed(String)
    }

    private var totalVolume: Double {
        session.completedExercises
            .flatMap { $0.sets }
            .reduce(0) { $0 + $1.weight * Double($1.reps) }
    }

    private var duration: String {
        let elapsed = Int(Date().timeIntervalSince(session.startDate)) / 60
        let hours = elapsed / 60
        let minutes = elapsed % 60
        return String(format: "%dh %02dm", hours, minutes)
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: Spacing.md) {
                Text("Workout Complete!")
                    .foregroundColor(.textPrimary)
                    .font(.headlineLarge)

                HStack {
                    Group {
                        Text("\(Date().formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))")
                        Text("•")
                        Text("\(session.workout.name)")
                    }
                    .foregroundColor(.textSecondary)
                    .font(.labelMedium)
                }

                HStack {
                    VolumeCard(volume: totalVolume)
                    DurationCard(duration: duration)
                }

                saveStatusView

                AscendButton("Done") {
                    navigation.goHome()
                }
            }
            .padding(Spacing.screenPadding)
        }
        .task {
            await session.save()
            if let error = session.saveError {
                saveStatus = .failed(error)
            } else {
                saveStatus = .saved
            }
        }
    }

    @ViewBuilder
    private var saveStatusView: some View {
        switch saveStatus {
        case .saving:
            HStack(spacing: Spacing.xs) {
                ProgressView()
                Text("Saving session...")
                    .foregroundColor(.textSecondary)
                    .font(.labelMedium)
            }
        case .saved:
            Text("Saved to backend")
                .foregroundColor(.success)
                .font(.labelMedium)
        case .failed(let message):
            VStack(spacing: Spacing.xs) {
                Text("Save failed")
                    .foregroundColor(.error)
                    .font(.labelMedium)
                Text(message)
                    .foregroundColor(.textSecondary)
                    .font(.labelSmall)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }
        }
    }
}

struct VolumeCard: View {
    let volume: Double
    var body: some View {
        InfoCard(title: "TOTAL VOLUME", info: "\(volume.formatted())")
    }
}

struct DurationCard: View {
    let duration: String

    var body: some View {
        InfoCard(title: "DURATION", info: duration)
    }
}
