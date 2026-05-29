import ActivityKit
import Foundation

struct RestTimerActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var deadline: Date
        var startedAt: Date
    }

    var exerciseName: String
    var totalDuration: Int
}
