import SwiftUI

enum AppTypography {
    static let largeTitle = manrope(
        size: 35,
        weight: .heavy,
        relativeTo: .largeTitle
    )

    static let screenTitle = manrope(
        size: 29,
        weight: .bold,
        relativeTo: .title
    )

    static let sectionTitle = manrope(
        size: 23,
        weight: .bold,
        relativeTo: .title2
    )

    static let cardTitle = manrope(
        size: 19,
        weight: .bold,
        relativeTo: .headline
    )

    static let metric = manrope(
        size: 24,
        weight: .bold,
        relativeTo: .title2
    )

    static let body = dmSans(
        size: 15,
        weight: .regular,
        relativeTo: .body
    )

    static let bodyMedium = dmSans(
        size: 15,
        weight: .medium,
        relativeTo: .body
    )

    static let button = dmSans(
        size: 13,
        weight: .bold,
        relativeTo: .callout
    )

    static let caption = dmSans(
        size: 11,
        weight: .medium,
        relativeTo: .caption
    )

    static let overline = dmSans(
        size: 10,
        weight: .bold,
        relativeTo: .caption2
    )

    private static func manrope(
        size: CGFloat,
        weight: Font.Weight,
        relativeTo textStyle: Font.TextStyle
    ) -> Font {
        Font.custom(
            FontNames.manrope,
            size: size,
            relativeTo: textStyle
        )
        .weight(weight)
    }

    private static func dmSans(
        size: CGFloat,
        weight: Font.Weight,
        relativeTo textStyle: Font.TextStyle
    ) -> Font {
        Font.custom(
            FontNames.dmSans,
            size: size,
            relativeTo: textStyle
        )
        .weight(weight)
    }
}

private enum FontNames {
    // Confirm these against the fonts' internal PostScript names.
    static let manrope = "Manrope"
    static let dmSans = "DM Sans"
}

// MARK: - Reusable Text Styles

struct OverlineTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.overline)
            .foregroundStyle(AppColors.textSecondary)
            .tracking(1.3)
            .textCase(.uppercase)
    }
}

struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.sectionTitle)
            .foregroundStyle(AppColors.ink)
            .tracking(-0.5)
    }
}

extension View {
    func overlineStyle() -> some View {
        modifier(OverlineTextStyle())
    }

    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }
}
