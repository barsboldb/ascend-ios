import Foundation;

struct WorkoutProgram: Identifiable, Codable {
    let id: UUID;
    let name: String;
    let workouts: [WorkoutDay];
    let createdAt: Date;
    let updatedAt: Date;

    var serverId: String?;
    
    init(name: String, workouts: [WorkoutDay], serverId: String? = nil) {
        self.id = UUID();
        self.name = name;
        self.workouts = workouts;
        self.createdAt = Date();
        self.updatedAt = Date();
        self.serverId = serverId;
    }
}
