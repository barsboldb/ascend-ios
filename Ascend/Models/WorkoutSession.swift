import Foundation;

struct WorkoutSession: Identifiable, Codable {
    let id: UUID;
    let workoutDayId: UUID; // Reference to which WorkoutDay template
    let date: Date;
    let completedExercises: [CompletedExercises];
    let duration: Int?;
    let notes: String?;

    init(workoutDayId: UUID, date: Date = Date(), completedExercises: [CompletedExercises] = [], duration: Int? = nil, notes: String? = nil) {
        self.id = UUID();
        self.workoutDayId = workoutDayId;
        self.date = date;
        self.completedExercises = completedExercises;
        self.duration = duration;
        self.notes = notes;
    }
}

struct CompletedExercises: Identifiable, Codable {
    let id: UUID;
    let exerciseName: String;
    let sets: [CompletedSet];

    init(exerciseName: String, sets: [CompletedSet] = []) {
        self.id = UUID();
        self.exerciseName = exerciseName;
        self.sets = sets;
    }
}

struct CompletedSet: Identifiable, Codable {
    let id: UUID;
    let reps: Int;
    let weight: Double;
    let completed: Bool;

    init(reps: Int, weight: Double, completed: Bool = false) {
        self.id = UUID();
        self.reps = reps;
        self.weight = weight;
        self.completed = completed;
    }
}
