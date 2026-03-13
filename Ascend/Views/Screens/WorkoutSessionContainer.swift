import SwiftUI

struct WorkoutSessionContainer: View {
    @StateObject private var session: ActiveWorkoutSession

    init(workout: WorkoutDay) {
        _session = StateObject(wrappedValue: ActiveWorkoutSession(workout: workout))
    }

    var body: some View {
        TodaysWorkoutView()
            .environmentObject(session)
    }
}
