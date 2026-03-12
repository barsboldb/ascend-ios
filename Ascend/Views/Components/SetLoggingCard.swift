import SwiftUI

struct SetLoggingCard: View {
    let setNumber: Int
    let totalSets: Int
    let weightIncrement: Double

    @Binding var weight: Double
    @Binding var reps: Int
    @Binding var rpe: Int

    var body: some View {
        VStack(spacing: Spacing.md) {
            StepperField(
                label: "WEIGHT",
                unit: "kg",
                value: $weight,
                step: weightIncrement,
                minimum: 0,
            )

            StepperField(
                label: "REPS",
                unit: nil,
                value: Binding(
                    get: { Double(reps) },
                    set: { reps = Int($0) },
                ),
                step: 1,
                minimum: 1,
            )

            RPESlider(rpe: $rpe)
        }
    }
}

