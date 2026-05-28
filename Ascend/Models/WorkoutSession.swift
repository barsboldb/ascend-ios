import Foundation;

struct WorkoutSession: Identifiable, Codable, Hashable {
    let id: UUID;
    let workoutDayId: UUID; // Reference to which WorkoutDay template
    let date: Date;
    let completedExercises: [CompletedExercise];
    let duration: Int?;
    let bodyWeight: Double?;
    let notes: String?;

    init(
        workoutDayId: UUID,
        date: Date = Date(), 
        completedExercises: [CompletedExercise] = [], 
        duration: Int? = nil, 
        bodyWeight: Double? = nil, 
        notes: String? = nil,
    ) {
        self.id = UUID();
        self.workoutDayId = workoutDayId;
        self.date = date;
        self.completedExercises = completedExercises;
        self.duration = duration;
        self.bodyWeight = bodyWeight;
        self.notes = notes;
    }
}

struct CompletedExercise: Identifiable, Codable, Hashable {
    let id: UUID;
    let exerciseId: UUID?;
    let exerciseName: String;
    let sets: [CompletedSet];
    let notes: String?

    init(exerciseId: UUID? = nil, exerciseName: String, sets: [CompletedSet] = [], notes: String? = nil) {
        self.id = UUID();
        self.exerciseId = exerciseId;
        self.exerciseName = exerciseName;
        self.sets = sets;
        self.notes = notes;
    }
}

struct CompletedSet: Identifiable, Codable, Hashable {
    let id: UUID;
    let reps: Int;
    let weight: Double;
    let rpe: Int?;
    let completed: Bool;
    let notes: String?;

    init(
        reps: Int, 
        weight: Double, 
        rpe: Int? = nil,
        completed: Bool = false,
        notes: String? = nil,
    ) {
        self.id = UUID();
        self.reps = reps;
        self.weight = weight;
        self.rpe = rpe;
        self.completed = completed;
        self.notes = notes;
    }
}
