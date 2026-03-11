import SwiftUI

enum AscendButtonVariant {
    case primary, secondary, destructive, ghost
}

enum AscendButtonSize {
    case small, medium, large
}

struct AscendButton: View {
    let title: String
    let variant: AscendButtonVariant
    let size: AscendButtonSize
    let fullWidth: Bool
    let icon: String?
    let action: () -> Void

    init(
        _ title: String,
        variant: AscendButtonVariant = .primary,
        size: AscendButtonSize = .medium,
        fullWidth: Bool = false,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.fullWidth = fullWidth
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(iconFont)
                }

                Text(title)
                    .font(textFont)
            }.frame(maxWidth: fullWidth ? .infinity : nil)
        }.buttonStyle(AscendButtonStyle(variant: variant, size: size))
    }

    private var iconFont: Font {
        switch size {
        case .small: return .labelSmall
        case .medium: return .labelMedium
        case .large: return .labelLarge
        }
    }

    private var textFont: Font {
        switch size {
        case .small: return .labelMedium
        case .medium: return .labelLarge
        case .large: return .titleMedium
        }
    }
}

struct AscendButtonStyle: ButtonStyle {
    let variant: AscendButtonVariant
    let size: AscendButtonSize

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .small: return Spacing.xs
        case .medium: return Spacing.sm
        case .large: return Spacing.md
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return Spacing.sm
        case .medium: return Spacing.buttonPadding
        case .large: return Spacing.lg
        }
    }

    private var cornerRadius: CGFloat {
        switch size {
        case .small: return Spacing.radiusSmall
        case .medium: return Spacing.radiusMedium
        case .large: return Spacing.radiusLarge
        }
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        let opacity = isPressed ? 0.8 : 1.0

        switch variant {
        case .primary:
            return Color.primary.opacity(opacity)
        case .secondary:
            return Color.surface.opacity(opacity)
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
