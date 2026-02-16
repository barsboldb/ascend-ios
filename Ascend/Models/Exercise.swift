import Foundation;

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID;
    let name: String;
    let sets: Int;
    let repRange: String;
    let targetWeight: Double;
    let restSeconds: Int;
    let notes: String?;

    init(name: String, sets: Int, repRange: String, targetWeight: Double, restSeconds: Int, notes: String? = nil) {
        self.id = UUID();
        self.name = name;
        self.sets = sets;
        self.repRange = repRange;
        self.targetWeight = targetWeight;
        self.restSeconds = restSeconds;
        self.notes = notes;
    }
}
