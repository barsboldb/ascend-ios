import SwiftUI

struct SessionDetailView: View {
    @EnvironmentObject var navigation: NavigationState
    @State var session: WorkoutSession
    let workoutName: String?
    let onSessionChanged: () async -> Void

    @State private var editingSet: CompletedSet? = nil
    @State private var editingExerciseName: String = ""
    @State private var showDeleteConfirm = false
    @State private var deleting = false
    @State private var actionError: String? = nil

    private var sets: [CompletedSet] { session.completedExercises.flatMap { $0.sets } }
    private var volume: Double { sets.reduce(0) { $0 + $1.weight * Double($1.reps) } }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    header
                    summary
                    exercisesList
                    deleteButton
                    if let actionError {
                        Text(actionError)
                            .font(.labelSmall)
                            .foregroundColor(.error)
                    }
                }
                .padding(Spacing.screenPadding)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(item: $editingSet) { set in
            SetEditSheet(
                set: set,
                exerciseName: editingExerciseName,
                onSave: { updated in
                    Task { await commitSetEdit(updated) }
                    editingSet = nil
                }
            )
            .presentationDetents([.medium])
        }
        .alert("Delete this session?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                Task { await commitDelete() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently removes the session and all its sets.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(workoutName ?? "Session")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
            Text(session.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.titleMedium)
                .foregroundColor(.textPrimary)
            if let duration = session.duration {
                Text("\(duration) min")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
            }
        }
    }

    private var summary: some View {
        HStack(spacing: Spacing.md) {
            summaryCard(value: "\(sets.count)", caption: "sets")
            summaryCard(value: "\(Int(volume))", caption: "volume kg")
            summaryCard(value: "\(session.completedExercises.count)", caption: "exercises")
        }
    }

    private func summaryCard(value: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(value)
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            Text(caption)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusMedium)
    }

    private var exercisesList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            ForEach(session.completedExercises) { exercise in
                ExerciseBreakdown(
                    exercise: exercise,
                    onEditSet: { set in
                        editingExerciseName = exercise.exerciseName
                        editingSet = set
                    }
                )
            }
        }
    }

    private var deleteButton: some View {
        AscendButton("Delete Session", variant: .destructive, size: .large, fullWidth: true) {
            showDeleteConfirm = true
        }
        .disabled(deleting)
    }

    private func commitDelete() async {
        deleting = true
        defer { deleting = false }
        do {
            if #available(iOS 18.0, *) {
                try await GRPCHistoryRepository.shared.deleteSession(id: session.id)
                await onSessionChanged()
                await MainActor.run { navigation.goBack() }
            }
        } catch {
            actionError = "Delete failed: \(error)"
        }
    }

    private func commitSetEdit(_ updated: CompletedSet) async {
        do {
            if #available(iOS 18.0, *) {
                try await GRPCHistoryRepository.shared.updateSet(
                    id: updated.id,
                    weight: updated.weight,
                    reps: updated.reps,
                    rpe: updated.rpe
                )
                await MainActor.run { applyLocalUpdate(updated) }
                await onSessionChanged()
            }
        } catch {
            actionError = "Update failed: \(error)"
        }
    }

    private func applyLocalUpdate(_ updated: CompletedSet) {
        let newExercises = session.completedExercises.map { exercise -> CompletedExercise in
            guard exercise.sets.contains(where: { $0.id == updated.id }) else { return exercise }
            let newSets = exercise.sets.map { $0.id == updated.id ? updated : $0 }
            return CompletedExercise(
                exerciseId: exercise.exerciseId,
                exerciseName: exercise.exerciseName,
                sets: newSets,
                notes: exercise.notes
            )
        }
        session = WorkoutSession(
            workoutDayId: session.workoutDayId,
            date: session.date,
            completedExercises: newExercises,
            duration: session.duration,
            bodyWeight: session.bodyWeight,
            notes: session.notes
        )
    }
}

private struct ExerciseBreakdown: View {
    let exercise: CompletedExercise
    let onEditSet: (CompletedSet) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(exercise.exerciseName)
                .font(.titleMedium)
                .foregroundColor(.textPrimary)

            VStack(spacing: Spacing.xs) {
                ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                    Button {
                        onEditSet(set)
                    } label: {
                        HStack {
                            Text("\(index + 1)")
                                .font(.labelMedium)
                                .foregroundColor(.textSecondary)
                                .frame(width: 24, alignment: .leading)
                            Text("\(set.weight.formatted()) kg × \(set.reps)")
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                            Spacer()
                            if let rpe = set.rpe {
                                Text("RPE \(rpe)")
                                    .font(.labelMedium)
                                    .foregroundColor(.textSecondary)
                            }
                            Image(systemName: "pencil")
                                .font(.labelSmall)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .cornerRadius(Spacing.radiusLarge)
    }
}

private struct SetEditSheet: View {
    let set: CompletedSet
    let exerciseName: String
    let onSave: (CompletedSet) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var weight: Double
    @State private var reps: Int
    @State private var rpe: Int

    init(set: CompletedSet, exerciseName: String, onSave: @escaping (CompletedSet) -> Void) {
        self.set = set
        self.exerciseName = exerciseName
        self.onSave = onSave
        _weight = State(initialValue: set.weight)
        _reps = State(initialValue: set.reps)
        _rpe = State(initialValue: set.rpe ?? 0)
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(exerciseName)
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)

                stepperRow(label: "Weight (kg)", value: weight.formatted(),
                           onMinus: { weight = max(0, weight - 2.5) },
                           onPlus: { weight += 2.5 })

                stepperRow(label: "Reps", value: "\(reps)",
                           onMinus: { reps = max(0, reps - 1) },
                           onPlus: { reps += 1 })

                stepperRow(label: "RPE", value: rpe == 0 ? "—" : "\(rpe)",
                           onMinus: { rpe = max(0, rpe - 1) },
                           onPlus: { rpe = min(10, rpe + 1) })

                Spacer()

                HStack(spacing: Spacing.sm) {
                    AscendButton("Cancel", variant: .secondary, size: .large, fullWidth: true) {
                        dismiss()
                    }
                    AscendButton("Save", variant: .primary, size: .large, fullWidth: true) {
                        onSave(CompletedSet(
                            id: set.id,
                            reps: reps,
                            weight: weight,
                            rpe: rpe == 0 ? nil : rpe,
                            completed: set.completed,
                            notes: set.notes
                        ))
                    }
                }
            }
            .padding(Spacing.screenPadding)
        }
    }

    private func stepperRow(label: String, value: String, onMinus: @escaping () -> Void, onPlus: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
                Text(value)
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: value)
            }
            Spacer()
            HStack(spacing: Spacing.sm) {
                Button {
                    withAnimation { onMinus() }
                } label: {
                    Image(systemName: "minus")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Color.surface)
                        .cornerRadius(Spacing.radiusMedium)
                }
                Button {
                    withAnimation { onPlus() }
                } label: {
                    Image(systemName: "plus")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Color.surface)
                        .cornerRadius(Spacing.radiusMedium)
                }
            }
        }
    }
}
