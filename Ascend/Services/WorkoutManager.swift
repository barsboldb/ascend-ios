import SwiftUI

class WorkoutManager: ObservableObject {
    @Published var currentProgram: WorkoutProgram?
    @Published var workoutHistory: [WorkoutSession] = []

    private let programRepository: WorkoutProgramRepository
    private let historyRepository: WorkoutHistoryRepository
    
    init(
        programRepository: WorkoutProgramRepository? = nil,
        historyRepository: WorkoutHistoryRepository? = nil,
    ) {
        if let programRepository {
            self.programRepository = programRepository
        } else if #available(iOS 18.0, *) {
            self.programRepository = GRPCProgramRepository.shared
        } else {
            self.programRepository = LocalWorkoutRepository.shared
        }
        if let historyRepository {
            self.historyRepository = historyRepository
        } else if #available(iOS 18.0, *) {
            self.historyRepository = GRPCHistoryRepository.shared
        } else {
            self.historyRepository = LocalHistoryRepository.shared
        }
    }

    func saveSession(_ session: WorkoutSession) async {
        do {
            try await historyRepository.saveSession(session)
            workoutHistory = try await historyRepository.getAllSessions()
        } catch {
            print("Failed to save session: \(error)")
        }
    }

    func loadData() async {
        do {
            let programs = try await programRepository.getAllPrograms()
            currentProgram = programs.first

            workoutHistory = try await historyRepository.getAllSessions()
        } catch {
            print("Error: \(error)")
        }
    }

    func getTodaysWorkout() -> WorkoutDay? {
        guard let program = currentProgram else { return nil }

        let completedCount = workoutHistory.count
        let dayIndex = completedCount % program.workouts.count
        
        return program.workouts[dayIndex]
    }

    func getLastSession() -> WorkoutSession? {
        return workoutHistory.sorted(by: { $0.date > $1.date }).first
    }

    func getCurrentWeek() -> Int {
        let totalWorkouts = workoutHistory.count
        return (totalWorkouts / 6) + 1
    }
}
