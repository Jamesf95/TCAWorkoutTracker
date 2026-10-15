//
//  AppTheme.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI

// MARK: - App Theme

enum AppColors {
    
    // Core
    static let ink = Color(hex: 0x171916)
    static let textSecondary = Color(hex: 0x777C74)
    static let paper = Color(hex: 0xF5F5F0)
    static let surface = Color(hex: 0xFFFFFF)
    static let border = Color(hex: 0xE5E6DF)

    // Accents
    static let lime = Color(hex: 0xD8F365)
    static let limeDark = Color(hex: 0xC3E33C)
    static let coral = Color(hex: 0xF5B4A0)
    static let blue = Color(hex: 0xA9D8EF)
    static let violet = Color(hex: 0xC9B9EF)

    // Supporting
    static let canvas = Color(hex: 0xD8D9D1)
    static let phoneFrame = Color(hex: 0x242522)
    static let brandAccent = Color(hex: 0xA5C51D)
    static let notification = Color(hex: 0xED6D4E)
    static let destructive = Color(hex: 0xD46148)
    static let focusBorder = Color(hex: 0xA6BD42)
    static let selectedBorder = Color(hex: 0xD1DC9D)

    // Dark surfaces
    static let darkDivider = Color(hex: 0x3B3D39)
    static let darkInput = Color(hex: 0x242622)
    static let darkInputBorder = Color(hex: 0x3A3C38)

    // Muted UI
    static let textOnDarkMuted = Color(hex: 0xAEB1AA)
    static let navigationMuted = Color(hex: 0xA1A49E)
    static let progressTrack = Color(hex: 0xE1E2DA)
}


// MARK: - Font Weights

private enum AppFontWeight {
    case regular
    case medium
    case semibold
    case bold
    case extraBold

    var fontName: String {
        switch self {
        case .regular:
            return "Regular"
        case .medium:
            return "Medium"
        case .semibold:
            return "SemiBold"
        case .bold:
            return "Bold"
        case .extraBold:
            return "ExtraBold"
        }
    }
}

// MARK: - Hex Colors

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
