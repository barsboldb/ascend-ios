import SwiftUI

struct ExercisePreviewSection: View {
    let exercises: [Exercise]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Today's Exercises:")
                .font(.labelLarge)

            ForEach(exercises.prefix(4)) { exercise in
                HStack {
                    Text(exercise.name)
                        .font(.bodyMedium)
                    Spacer()
                    Text("\(exercise.sets)×\(exercise.repRange)")
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
