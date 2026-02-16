import Foundation;

struct WorkoutDay: Identifiable, Codable, Hashable {
    let id: UUID;
    let name: String;
    let type: WorkoutType;
    let variant: String;
    let warmup: [String]
    let exercises: [Exercise]
    let estimatedDuration: Int // in minutes

    init(name: String, type: WorkoutType, variant: String, warmup: [String], exercises: [Exercise], estimatedDuration: Int) {
        self.id = UUID();
        self.name = name;
        self.type = type;
        self.variant = variant;
        self.warmup = warmup;
        self.exercises = exercises;
        self.estimatedDuration = estimatedDuration;
    }
}

enum WorkoutType: String, Codable {
    case push;
    case pull;
    case legs;
}
