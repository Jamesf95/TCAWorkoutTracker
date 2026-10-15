import SwiftUI

struct LimeButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                    .font(AppTypography.button)
                    .foregroundStyle(AppColors.ink)
                    
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppColors.ink)
            }
            .padding(.horizontal, 18)
            .frame(minHeight: 48)
            .background(AppColors.lime, in: RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LimeButton(title: "Continue", action: {})
        .padding()
        .background(AppColors.canvas)
}
