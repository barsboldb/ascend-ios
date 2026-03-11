import Foundation

enum SetStatus {
    case pending
    case active
    case completed
}

struct SetLog: Identifiable {
    let id: UUID
    let targetWeight: Double
    let targetRepRange: String

    var loggedWeight: Double?
    var loggedReps: Int?
    var rpe: Int?

    var status: SetStatus
    var notes: String?
}
