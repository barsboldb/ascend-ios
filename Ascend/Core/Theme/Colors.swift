import SwiftUI

extension Color {
    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int);
        var a, r, g, b: UInt64;
        switch hex.count {
            case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB, 
            red: Double(r) / 255, 
            green: Double(g) / 255, 
            blue: Double(b) / 255, 
            opacity: Double(a) / 255)
    }

    // Primary Colors
    static let darkAmethyst = Color(hex: "120D31")
    static let royalPurple = Color(hex: "6366F1")
    static let softLavender = Color(hex: "A5B4FC")

    // Accent Colors
    static let cyberTeal = Color(hex: "06B6D4")
    static let amberGold = Color(hex: "F59E0B")
    static let coralPink = Color(hex: "EC4899")

    // Semantic Colors
    static let success = Color(hex: "10B981")
    static let error = Color(hex: "EF4444")
    static let info = Color(hex: "06B6D4")
    static let warning = amberGold

    // Neutral Colors
    static let midnight = Color(hex: "1E1B4B")
    static let slate = Color(hex: "475569")
    static let silver = Color(hex: "94A3B8")
    static let ghostWhite = Color(hex: "F8FAFC")

    // Semantic Alias Colors
    static let background = darkAmethyst
    static let surface = midnight
    static let primary = royalPurple
    static let secondary = cyberTeal
    static let accent = amberGold

    static let textPrimary = ghostWhite
    static let textSecondary = silver
}
