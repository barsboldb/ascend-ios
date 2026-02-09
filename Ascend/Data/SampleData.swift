struct SampleData {
    static let twicePerWeekPPL: WorkoutProgram = {
        let pushA = WorkoutDay(
            name: "Push Day A",
            type: .push,
            variant: "A",
            warmup: [
                "Jumping jacks or arm circles: 60 seconds",
                "Shoulder ascillations: 30 seconds",
                "Wall slides: 10-15 reps",
                "Scapular push-ups: 10 reps",
                "Inchworkms: 5-8reps",
                "Light push-ups: 10-15 reps",
                "Empty bar bench press: 2 x 10"
            ],
            exercises: [
                Exercise(name: "Flat Barbell Bench Press", sets: 4, repRange: "6-8", targetWeight: 32.5, restSeconds: 150),
                Exercise(name: "Inclined Dumbbell Press", sets: 3, repRange: "8-10", targetWeight: 11, restSeconds: 120, notes: "each arm"),
                Exercise(name: "Seated Dumbbell Shoulder Press", sets: 3, repRange: "10-12", targetWeight: 9, restSeconds: 90, notes: "each arm"),
                Exercise(name: "Overhead Tricep Extension", sets: 3, repRange: "10-12", targetWeight: 17.5, restSeconds: 75),
                Exercise(name: "Lateral Raises", sets: 3, repRange: "12-15", targetWeight: 5.5, restSeconds: 60),
                Exercise(name: "Tricep Rope Pushdowns", sets: 3, repRange: "12-15", targetWeight: 17.5, restSeconds: 60),
                Exercise(name: "Close-Grip Push-Ups", sets: 2, repRange: "AMRAP", targetWeight: 0, restSeconds: 60, notes: "bodyweight")
            ],
            estimatedDuration: 75,
        )

        let pushB = WorkoutDay(
            name: "Push Day B",
            type: .push,
            variant: "B",
            warmup: [
                "Jumping jacks or arm circles: 60 seconds",
                "Shoulder ascillations: 30 seconds",
                "Wall slides: 10-15 reps",
                "Scapular push-ups: 10 reps",
                "Inchworkms: 5-8reps",
                "Light push-ups: 10-15 reps",
                "Empty bar bench press: 2 x 10"
            ],
            exercises: [
                Exercise(name: "Standing Barbell Overhead Press", sets: 4, repRange: "6-8", targetWeight: 27.5, restSeconds: 150),
                Exercise(name: "Flat Dumbbell Bench Press", sets: 3, repRange: "8-10", targetWeight: 13, restSeconds: 120, notes: "each arm"),
                Exercise(name: "Cable Flyes", sets: 3, repRange: "10-12", targetWeight: 12.5, restSeconds: 90, notes: "low-to-high"),
                Exercise(name: "Skull Crushers", sets: 3, repRange: "10-12", targetWeight: 17.5, restSeconds: 75, notes: "EZ bar"),
                Exercise(name: "Lateral Raises", sets: 3, repRange: "12-15", targetWeight: 5.5, restSeconds: 60),
                Exercise(name: "Close-Grip Bench Press", sets: 3, repRange: "8-10", targetWeight: 27.5, restSeconds: 90),
                Exercise(name: "Diamond Push-Ups", sets: 2, repRange: "AMRAP", targetWeight: 0, restSeconds: 60, notes: "bodyweight")
            ],
            estimatedDuration: 75,
        )

        let pullA = WorkoutDay(
            name: "Pull Day A",
            type: .pull,
            variant: "A",
            warmup: [
                "Rowing machine or jumping jacks: 60 seconds",
                "Arm circles: 30 seconds each direction",
                "Band pull-aparts: 15-20 reps",
                "Cat-cow stretch: 10 reps",
                "Thoracic rotations: 8-10 each side",
                "Lat stretch/hang from bar: 30 seconds",
                "Light lat pulldowns: 2 × 12",
            ],
            exercises: [
                Exercise(name: "Barbell Bend-Over Row", sets: 4, repRange: "6-8", targetWeight: 37.5, restSeconds: 150),
                Exercise(name: "Lat Pulldown", sets: 3, repRange: "8-10", targetWeight: 37.5, restSeconds: 120),
                Exercise(name: "Face Pulls", sets: 3, repRange: "12-15", targetWeight: 12.5, restSeconds: 75),
                Exercise(name: "Barbell Curls", sets: 3, repRange: "8-10", targetWeight: 17.5, restSeconds: 75),
                Exercise(name: "Hammer Curls", sets: 3, repRange: "10-12", targetWeight: 9, restSeconds: 60),
                Exercise(name: "Incline Dumbbell Curls", sets: 2, repRange: "10-12", targetWeight: 7, restSeconds: 60),
                Exercise(name: "Rear Delt Flyes", sets: 2, repRange: "12-15", targetWeight: 7, restSeconds: 60)
            ],
            estimatedDuration: 75,
        )

        let pullB = WorkoutDay(
            name: "Pull Day B",
            type: .pull,
            variant: "B",
            warmup: [
                "Rowing machine or jumping jacks: 60 seconds",
                "Arm circles: 30 seconds each direction",
                "Band pull-aparts: 15-20 reps",
                "Cat-cow stretch: 10 reps",
                "Thoracic rotations: 8-10 each side",
                "Lat stretch/hang from bar: 30 seconds",
                "Light lat pulldowns: 2 × 12",
            ],
            exercises: [
                Exercise(name: "Pull-Ups", sets: 4, repRange: "AMRAP", targetWeight: -10, restSeconds: 150),
                Exercise(name: "Seated Cable Row", sets: 3, repRange: "8-10", targetWeight: 45, restSeconds: 120),
                Exercise(name: "Single-Arm Dumbbell Row", sets: 3, repRange: "10-12", targetWeight: 16, restSeconds: 90, notes: "each arm"),
                Exercise(name: "Preacher Curls", sets: 3, repRange: "8-10", targetWeight: 17.5, restSeconds: 75, notes: "EZ bar"),
                Exercise(name: "Concentration Curls", sets: 3, repRange: "10-12", targetWeight: 9, restSeconds: 60),
                Exercise(name: "Cable Curls", sets: 2, repRange: "12-15", targetWeight: 17.5, restSeconds: 60),
                Exercise(name: "Face Pulls", sets: 2, repRange: "15", targetWeight: 13.5, restSeconds: 60)
            ],
            estimatedDuration: 75,
        )

        let legA = WorkoutDay(
            name: "Legs Day A",
            type: .legs,
            variant: "A",
            warmup: [
                "Walking or stationary bike: 3-5 minutes",
                "Leg swings (front-back): 10-15 each leg",
                "Leg swings (side-to-side): 10-15 each leg",
                "Hip circles: 10 each direction",
                "Walking lunges: 10 total",
                "Bodyweight squats: 15-20 reps",
                "Glute bridges: 15 reps",
                "Sumo squat hold: 30 seconds",
                "Empty bar squats: 2 × 10",
            ],
            exercises: [
                Exercise(name: "Barbell Back Squat", sets: 4, repRange: "6-8", targetWeight: 45, restSeconds: 150),
                Exercise(name: "Romanian Deadlift", sets: 3, repRange: "8-10", targetWeight: 42.5, restSeconds: 120),
                Exercise(name: "Leg Press", sets: 3, repRange: "10-12", targetWeight: 90, restSeconds: 120),
                Exercise(name: "Leg Curls", sets: 3, repRange: "10-12", targetWeight: 30, restSeconds: 75),
                Exercise(name: "Standing Calf Raises", sets: 4, repRange: "12-15", targetWeight: 50, restSeconds: 60),
                Exercise(name: "Hanging Leg Raises", sets: 3, repRange: "10-15", targetWeight: 0, restSeconds: 60, notes: "core"),
                Exercise(name: "Dead Bug", sets: 2, repRange: "10", targetWeight: 0, restSeconds: 60, notes: "core, each side")
            ],
            estimatedDuration: 75,
        )

        let legB = WorkoutDay(
            name: "Legs Day B",
            type: .legs,
            variant: "B",
            warmup: [
                "Walking or stationary bike: 3-5 minutes",
                "Leg swings (front-back): 10-15 each leg",
                "Leg swings (side-to-side): 10-15 each leg",
                "Hip circles: 10 each direction",
                "Walking lunges: 10 total",
                "Bodyweight squats: 15-20 reps",
                "Glute bridges: 15 reps",
                "Sumo squat hold: 30 seconds",
                "Empty bar squats: 2 × 10",
            ],
            exercises: [
                Exercise(name: "Conventional Deadlift", sets: 4, repRange: "5-6", targetWeight: 55, restSeconds: 180),
                Exercise(name: "Front Squat", sets: 3, repRange: "8-10", targetWeight: 35, restSeconds: 120),
                Exercise(name: "Walking Lunges", sets: 3, repRange: "10", targetWeight: 11, restSeconds: 90, notes: "each side"),
                Exercise(name: "Leg Curls", sets: 3, repRange: "10-12", targetWeight: 30, restSeconds: 75),
                Exercise(name: "Seated Calf Raises", sets: 4, repRange: "15-20", targetWeight: 35, restSeconds: 60),
                Exercise(name: "Plank", sets: 3, repRange: "45-60 sec", targetWeight: 0, restSeconds: 60, notes: "core"),
                Exercise(name: "Pallof Press", sets: 2, repRange: "10", targetWeight: 12.5, restSeconds: 60, notes: "core, each side")
            ],
            estimatedDuration: 75,
        )

        return WorkoutProgram(
            name: "2x PPL Program",
            workouts: [pushA, pullA, legA, pushB, pullB, legB],
        );
    }();
}
