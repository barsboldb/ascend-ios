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
        let workouts = nonRestWorkouts
        guard !workouts.isEmpty else { return nil }

        if let last = getLastSession(),
           let idx = workouts.firstIndex(where: { $0.id == last.workoutDayId }) {
            return workouts[(idx + 1) % workouts.count]
        }
        return workouts.first
    }

    func getLastSession() -> WorkoutSession? {
        return workoutHistory.sorted(by: { $0.date > $1.date }).first
    }

    func getCurrentDayNumber() -> Int {
        let workouts = nonRestWorkouts
        guard let next = getTodaysWorkout(),
              let idx = workouts.firstIndex(where: { $0.id == next.id }) else {
            return 1
        }
        return idx + 1
    }

    func getCurrentWeek() -> Int {
        let perWeek = max(nonRestWorkouts.count, 1)
        let thirtyDaysAgo = Date().addingTimeInterval(-30 * 24 * 3600)
        let recent = workoutHistory.filter { $0.date >= thirtyDaysAgo }
        return recent.count / perWeek + 1
    }

    private var nonRestWorkouts: [WorkoutDay] {
        currentProgram?.workouts.filter { !$0.exercises.isEmpty } ?? []
    }
}
