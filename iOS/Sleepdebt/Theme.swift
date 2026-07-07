import SwiftUI

/// Bespoke palette + type for Sleepdebt - Sleep Debt Tally.
enum Theme {
    static let background = Color(hex: "#101120")
    static let primary = Color(hex: "#2B2D42")
    static let secondary = Color(hex: "#6C6F9B")
    static let accent = Color(hex: "#EF476F")
    static let cardBackground = Color(hex: "#101120").opacity(0.6)

    static let titleFont = Font.custom("Futura", size: 28).weight(.bold)
    static let headlineFont = Font.custom("Futura", size: 18).weight(.semibold)
    static let bodyFont = Font.custom("Futura", size: 16)
    static let captionFont = Font.custom("Futura", size: 13)
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
