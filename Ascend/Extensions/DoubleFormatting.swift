import Foundation

extension Double {
    func formatted(significantDigits: Int = 3) -> String {
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = significantDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
