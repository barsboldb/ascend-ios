import Foundation;

enum ExerciseTag: String, Codable {
    case squat
    case hinge
    case upperPush
    case upperPull
    case isolation

    var increment: Double {
        switch self {
        case .squat, .hinge:           return 2.5
        case .upperPush, .upperPull:   return 1.25
        case .isolation:               return 1.25
        }
    }
}

enum ExerciseType: String, Codable {
    case reps
    case hold
    case amrap
}

struct RepRange: Codable, Hashable {
    let min: Int
    let max: Int
}


struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID;
    let name: String;
    let sets: Int;
    let repRange: RepRange;
    let targetWeight: Double;
    let restSeconds: Int;
    let tag: ExerciseTag;
    let type: ExerciseType;
    let notes: String?;

    init(name: String, sets: Int, repRange: RepRange, targetWeight: Double, restSeconds: Int, tag: ExerciseTag, type: ExerciseType = .reps, notes: String? = nil) {
        self.id = UUID();
        self.name = name;
        self.sets = sets;
        self.repRange = repRange;
        self.targetWeight = targetWeight;
        self.restSeconds = restSeconds;
        self.tag = tag;
        self.type = type;
        self.notes = notes;
    }
}
