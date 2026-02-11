import Foundation

struct SampleData {
    static let twicePerWeekPPL: WorkoutProgram = {
        let pushA = WorkoutDay(
            name: "Push A",
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
            name: "Push B",
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
            name: "Pull A",
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
            name: "Pull B",
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
            name: "Legs A",
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
            name: "Legs B",
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

    static let workoutHistory: [WorkoutSession] = {
        let program = twicePerWeekPPL

        func findWorkout(_ name: String) -> UUID {
              program.workouts.first(where: { $0.name.contains(name) })?.id ?? UUID()
        }

        return [
            // 2.7 Saturday - Pull B
            WorkoutSession(
              workoutDayId: findWorkout("Pull B"),
              date: date(year: 2026, month: 2, day: 7),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Pull-Ups",
                      sets: [
                          CompletedSet(reps: 8, weight: -20, rpe: 10),
                          CompletedSet(reps: 8, weight: -20, rpe: 10),
                          CompletedSet(reps: 8, weight: -20, rpe: 10),
                          CompletedSet(reps: 8, weight: -20, rpe: 10)
                      ],
                      notes: "Assisted"
                  ),
                  CompletedExercise(
                      exerciseName: "Seated Cable Row",
                      sets: [
                          CompletedSet(reps: 8, weight: 40, rpe: 8),
                          CompletedSet(reps: 8, weight: 40, rpe: 8),
                          CompletedSet(reps: 8, weight: 40, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Single-Arm Dumbbell Row",
                      sets: [
                          CompletedSet(reps: 10, weight: 15, rpe: 8),
                          CompletedSet(reps: 10, weight: 15, rpe: 8),
                          CompletedSet(reps: 10, weight: 15, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Incline Dumbbell Curls",
                      sets: [
                          CompletedSet(reps: 12, weight: 5, rpe: 8),
                          CompletedSet(reps: 12, weight: 5, rpe: 8),
                          CompletedSet(reps: 12, weight: 5, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Preacher Curls",
                      sets: [
                          CompletedSet(reps: 12, weight: 15, rpe: 9),
                          CompletedSet(reps: 12, weight: 15, rpe: 9),
                          CompletedSet(reps: 12, weight: 15, rpe: 10, notes: "Hit failure")
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Face Pulls",
                      sets: [
                          CompletedSet(reps: 15, weight: 15, rpe: 7),
                          CompletedSet(reps: 15, weight: 15, rpe: 7)
                      ]
                  )
              ],
              duration: 70
            ),

            // 2.6 Friday - Push B
            WorkoutSession(
              workoutDayId: findWorkout("Push B"),
              date: date(year: 2026, month: 2, day: 6),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Standing Barbell Overhead Press",
                      sets: [
                          CompletedSet(reps: 8, weight: 25, rpe: 9),
                          CompletedSet(reps: 8, weight: 25, rpe: 9),
                          CompletedSet(reps: 8, weight: 25, rpe: 9),
                          CompletedSet(reps: 8, weight: 25, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Flat Dumbbell Bench Press",
                      sets: [
                          CompletedSet(reps: 10, weight: 12.5, rpe: 8),
                          CompletedSet(reps: 10, weight: 12.5, rpe: 8),
                          CompletedSet(reps: 10, weight: 12.5, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Cable Flyes",
                      sets: [
                          CompletedSet(reps: 10, weight: 10, rpe: 10),
                          CompletedSet(reps: 10, weight: 10, rpe: 10),
                          CompletedSet(reps: 10, weight: 10, rpe: 10)
                      ],
                      notes: "Each arm"
                  ),
                  CompletedExercise(
                      exerciseName: "Skull Crushers",
                      sets: [
                          CompletedSet(reps: 10, weight: 15, rpe: 10),
                          CompletedSet(reps: 10, weight: 15, rpe: 10),
                          CompletedSet(reps: 10, weight: 15, rpe: 10)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Lateral Raises",
                      sets: [
                          CompletedSet(reps: 15, weight: 5, rpe: 9),
                          CompletedSet(reps: 15, weight: 5, rpe: 9),
                          CompletedSet(reps: 15, weight: 5, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Close-Grip Bench Press",
                      sets: [
                          CompletedSet(reps: 10, weight: 30, rpe: 9),
                          CompletedSet(reps: 10, weight: 30, rpe: 9),
                          CompletedSet(reps: 10, weight: 30, rpe: 9)
                      ]
                  )
              ],
              duration: 75
            ),

            // 2.5 Thursday - Leg A
            WorkoutSession(
              workoutDayId: findWorkout("Legs A"),
              date: date(year: 2026, month: 2, day: 5),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Barbell Back Squat",
                      sets: [
                          CompletedSet(reps: 8, weight: 50, rpe: 7),
                          CompletedSet(reps: 8, weight: 50, rpe: 7),
                          CompletedSet(reps: 8, weight: 50, rpe: 7),
                          CompletedSet(reps: 8, weight: 50, rpe: 7)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Romanian Deadlift",
                      sets: [
                          CompletedSet(reps: 8, weight: 50, rpe: 9),
                          CompletedSet(reps: 8, weight: 50, rpe: 9),
                          CompletedSet(reps: 8, weight: 50, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Leg Press",
                      sets: [
                          CompletedSet(reps: 12, weight: 90, rpe: 9),
                          CompletedSet(reps: 12, weight: 90, rpe: 9),
                          CompletedSet(reps: 12, weight: 90, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Leg Curls",
                      sets: [
                          CompletedSet(reps: 12, weight: 10, rpe: 9),
                          CompletedSet(reps: 12, weight: 10, rpe: 9),
                          CompletedSet(reps: 12, weight: 10, rpe: 9)
                      ],
                      notes: "Each leg"
                  ),
                  CompletedExercise(
                      exerciseName: "Standing Calf Raises",
                      sets: [
                          CompletedSet(reps: 15, weight: 50, rpe: 8),
                          CompletedSet(reps: 15, weight: 50, rpe: 8),
                          CompletedSet(reps: 15, weight: 50, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Hanging Leg Raises",
                      sets: [
                          CompletedSet(reps: 12, weight: 0, rpe: 9),
                          CompletedSet(reps: 12, weight: 0, rpe: 9),
                          CompletedSet(reps: 12, weight: 0, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Dead Bug",
                      sets: [
                          CompletedSet(reps: 12, weight: 0, rpe: 9),
                          CompletedSet(reps: 10, weight: 0, rpe: 9)
                      ]
                  )
              ],
              duration: 90
            ),

            // 2.4 Wednesday - Pull A
            WorkoutSession(
              workoutDayId: findWorkout("Pull A"),
              date: date(year: 2026, month: 2, day: 4),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Barbell Bent-Over Row",
                      sets: [
                          CompletedSet(reps: 8, weight: 40, rpe: 7),
                          CompletedSet(reps: 8, weight: 40, rpe: 7),
                          CompletedSet(reps: 8, weight: 40, rpe: 7),
                          CompletedSet(reps: 8, weight: 40, rpe: 7)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Lat Pulldown",
                      sets: [
                          CompletedSet(reps: 12, weight: 35, rpe: 8),
                          CompletedSet(reps: 12, weight: 35, rpe: 8),
                          CompletedSet(reps: 12, weight: 35, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Face Pulls",
                      sets: [
                          CompletedSet(reps: 15, weight: 20, rpe: 9),
                          CompletedSet(reps: 15, weight: 20, rpe: 9),
                          CompletedSet(reps: 15, weight: 20, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Barbell Curls",
                      sets: [
                          CompletedSet(reps: 15, weight: 15, rpe: 7),
                          CompletedSet(reps: 15, weight: 15, rpe: 7),
                          CompletedSet(reps: 15, weight: 15, rpe: 7)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Hammer Curls",
                      sets: [
                          CompletedSet(reps: 10, weight: 7.5, rpe: 10),
                          CompletedSet(reps: 10, weight: 7.5, rpe: 10),
                          CompletedSet(reps: 10, weight: 7.5, rpe: 10)
                      ],
                      notes: "Right hit failure"
                  ),
                  CompletedExercise(
                      exerciseName: "Rear Delt Flyes",
                      sets: [
                          CompletedSet(reps: 12, weight: 7.5, rpe: 9),
                          CompletedSet(reps: 12, weight: 7.5, rpe: 9)
                      ]
                  )
              ],
              duration: nil
            ),

            // 2.3 Tuesday - Push A
            WorkoutSession(
              workoutDayId: findWorkout("Push A"),
              date: date(year: 2026, month: 2, day: 3),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Flat Barbell Bench Press",
                      sets: [
                          CompletedSet(reps: 8, weight: 40, rpe: 8),
                          CompletedSet(reps: 8, weight: 40, rpe: 8),
                          CompletedSet(reps: 8, weight: 40, rpe: 8),
                          CompletedSet(reps: 8, weight: 40, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Incline Dumbbell Press",
                      sets: [
                          CompletedSet(reps: 10, weight: 5, rpe: 8),
                          CompletedSet(reps: 10, weight: 5, rpe: 8),
                          CompletedSet(reps: 10, weight: 5, rpe: 8)
                      ],
                      notes: "Deloaded to fix form"
                  ),
                  CompletedExercise(
                      exerciseName: "Seated Dumbbell Shoulder Press",
                      sets: [
                          CompletedSet(reps: 12, weight: 7.5, rpe: 10),
                          CompletedSet(reps: 12, weight: 7.5, rpe: 10),
                          CompletedSet(reps: 12, weight: 7.5, rpe: 10)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Overhead Tricep Extension",
                      sets: [
                          CompletedSet(reps: 10, weight: 15, rpe: 10),
                          CompletedSet(reps: 10, weight: 15, rpe: 10)
                      ],
                      notes: "Pain in left tricep, switched to rope pushdown for last set"
                  ),
                  CompletedExercise(
                      exerciseName: "Tricep Rope Pushdowns",
                      sets: [
                          CompletedSet(reps: 10, weight: 20, rpe: 10),
                          CompletedSet(reps: 15, weight: 15, rpe: 10),
                          CompletedSet(reps: 15, weight: 15, rpe: 10),
                          CompletedSet(reps: 15, weight: 15, rpe: 10)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Lateral Raises",
                      sets: [
                          CompletedSet(reps: 15, weight: 5, rpe: 10),
                          CompletedSet(reps: 15, weight: 5, rpe: 10),
                          CompletedSet(reps: 15, weight: 5, rpe: 10)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Close-Grip Push-Ups",
                      sets: [
                          CompletedSet(reps: 6, weight: 0, rpe: nil),
                          CompletedSet(reps: 6, weight: 0, rpe: nil)
                      ]
                  )
              ],
              duration: 80
            ),

            // 2.2 Monday - Leg B
            WorkoutSession(
              workoutDayId: findWorkout("Legs B"),
              date: date(year: 2026, month: 2, day: 2),
              completedExercises: [
                  CompletedExercise(
                      exerciseName: "Conventional Deadlift",
                      sets: [
                          CompletedSet(reps: 6, weight: 60, rpe: 8),
                          CompletedSet(reps: 6, weight: 60, rpe: 8),
                          CompletedSet(reps: 6, weight: 60, rpe: 8),
                          CompletedSet(reps: 6, weight: 60, rpe: 8)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Front Squat",
                      sets: [
                          CompletedSet(reps: 10, weight: 40, rpe: 9),
                          CompletedSet(reps: 10, weight: 40, rpe: 9),
                          CompletedSet(reps: 10, weight: 40, rpe: 9)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Walking Lunges",
                      sets: [
                          CompletedSet(reps: 10, weight: 12.5, rpe: 9),
                          CompletedSet(reps: 10, weight: 12.5, rpe: 9),
                          CompletedSet(reps: 10, weight: 12.5, rpe: 9)
                      ],
                      notes: "Each leg"
                  ),
                  CompletedExercise(
                      exerciseName: "Leg Curls",
                      sets: [
                          CompletedSet(reps: 12, weight: 10, rpe: 8),
                          CompletedSet(reps: 12, weight: 10, rpe: 8),
                          CompletedSet(reps: 12, weight: 10, rpe: 8)
                      ],
                      notes: "Each leg"
                  ),
                  CompletedExercise(
                      exerciseName: "Seated Calf Raises",
                      sets: [
                          CompletedSet(reps: 20, weight: 40, rpe: 6),
                          CompletedSet(reps: 20, weight: 40, rpe: 6),
                          CompletedSet(reps: 20, weight: 40, rpe: 6)
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Plank",
                      sets: [
                          CompletedSet(reps: 60, weight: 0, rpe: 8, notes: "60 seconds"),
                          CompletedSet(reps: 60, weight: 0, rpe: 8, notes: "60 seconds"),
                          CompletedSet(reps: 60, weight: 0, rpe: 8, notes: "60 seconds")
                      ]
                  ),
                  CompletedExercise(
                      exerciseName: "Pallof Press",
                      sets: [
                          CompletedSet(reps: 10, weight: 20, rpe: 7),
                          CompletedSet(reps: 10, weight: 20, rpe: 7)
                      ],
                      notes: "Each side"
                  )
              ],
              duration: 80
            )
        ]
    }()

      // Helper function to create dates
    private static func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 10
        return Calendar.current.date(from: components) ?? Date()
    }
}
