import SwiftUI

enum AscendButtonVariant {
    case primary, secondary, destructive, ghost
}

struct AscendButtonStyle: ButtonStyle {
    let variant: AscendButtonVariant

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.labelLarge)
            .foregroundColor(foregroundColor)
            .padding(.vertical, Spacing.sm)
            .padding(.horizontal, Spacing.buttonPadding)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .cornerRadius(Spacing.radiusMedium)
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        let opacity = isPressed ? 0.8 : 1.0

        switch variant {
        case .primary:
            return Color.primary.opacity(opacity)
        case .secondary:
            return Color.secondary.opacity(opacity)
        case .destructive:
            return Color.error.opacity(opacity)
        case .ghost:
            return Color.clear
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .ghost:
            return .primary
        default:
            return .textPrimary
        }
    }
}
