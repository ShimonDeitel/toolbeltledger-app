import SwiftUI

/// Bespoke palette for Toolbelt Ledger -- Track power-tool batteries, chargers, and which ones need replacing.
enum Theme {
    static let accent = Color(hex: "#D6A420")
    static let background = Color(hex: "#181410")
    static let backgroundSecondary = Color(hex: "#221C15")
    static let card = Color(hex: "#2B2419")
    static let textPrimary = Color(hex: "#F6EFDF")
    static let textSecondary = Color(hex: "#DCC689")

    static var titleFont: Font { Font.system(.title2, design: .monospaced).weight(.bold) }
    static var bodyFont: Font { Font.system(.body, design: .monospaced) }
    static var captionFont: Font { Font.system(.caption, design: .monospaced) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
