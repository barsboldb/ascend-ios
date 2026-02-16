import SwiftUI

struct ConfirmationModal: View {
    let title: String
    let message: String
    let confirmText: String
    let cancelText: String
    let confirmDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    init(
        title: String,
        message: String,
        confirmText: String = "Confirm",
        cancelText: String = "Cancel",
        confirmDestructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void,
    ) {
        self.title = title
        self.message = message
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.confirmDestructive = confirmDestructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: Spacing.lg) {
                VStack(spacing: Spacing.sm) {
                    Text(title)
                        .font(.headlineSmall)
                        .foregroundColor(.textPrimary)
                    Text(message)
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: Spacing.sm) {
                    AscendButton(
                        confirmText,
                        variant: confirmDestructive ? .destructive : .primary,
                        fullWidth: true,
                        action: onConfirm,
                    )

                    AscendButton(
                        cancelText,
                        variant: confirmDestructive ? .primary : .destructive,
                        fullWidth: true,
                        action: onCancel,
                    )
                }
            }
            .padding(Spacing.lg)
            .background(Color.surface)
            .cornerRadius(Spacing.radiusLarge)
            .shadow(color: Color.black.opacity(0.3), radius: 20, y: 20)
            .padding(Spacing.xl)
        }
    }
}
