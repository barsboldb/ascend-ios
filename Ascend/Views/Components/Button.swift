import SwiftUI

struct AscendButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.primary.opacity(0.8) : Color.primary)
            .foregroundColor(.white)
    }
}

enum AscendStyle {
    case primary, secondary, destructive, ghost
}
