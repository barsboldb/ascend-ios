import SwiftUI

struct StepperField: View {
    let label: String
    let unit: String?
    @Binding var value: Double
    let step: Double
    let minimum: Double

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Group {
                if let unit {
                    Text("\(label) (\(unit))")
                } else {
                    Text(label)
                }
            }
            .font(.labelMedium)
            .foregroundColor(.textSecondary)

            HStack(spacing: 0) {
                Button { value = max(minimum, value - step) } label: {
                    Image(systemName: "minus").frame(width: 44, height: 44)
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(width: 48, height: 48)
                        .background(Color.surface)
                        .clipShape(Circle())
                }

                Spacer()

                Text(value.formatted())
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .monospacedDigit()
                    .frame(minWidth: 130)
                    .contentTransition(.numericText(value: value))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: value)

                Spacer()

                Button { value += step } label: {
                    Image(systemName: "plus")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                        .frame(width: 48, height: 48)
                        .background(Color.surface)
                        .clipShape(Circle())
                }
            }
            .background(Color.background)
            .cornerRadius(Spacing.radiusMedium)
        }
        .frame(maxWidth: .infinity)
    }
}
