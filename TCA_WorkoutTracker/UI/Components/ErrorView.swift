//
//  ErrorView.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 13/10/2026.
//

import SwiftUI

struct ErrorView: View {
    
    let title: String
    let subtitle: String?
    let retryLabel: String
    let onRetryClicked: (() -> Void)?
    
    init(
        title: String = "Something went wrong!",
        subtitle: String? = nil,
        retryLabel: String = "Retry",
        onRetryClicked: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.retryLabel = retryLabel
        self.onRetryClicked = onRetryClicked
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.notification)
                .frame(width: 48, height: 48)
                .background(AppColors.coral.opacity(0.3), in: Circle())
            
            Text(title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppColors.ink)
                .multilineTextAlignment(.center)
            
            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let onRetryClicked {
                Button(action: onRetryClicked) {
                    Text(retryLabel)
                        .font(AppTypography.button)
                        .foregroundStyle(AppColors.inkOnDark)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 48)
                        .background(AppColors.ink, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.border, lineWidth: 1)
        }
    }
    
}

#Preview {
    ErrorView(subtitle: "Click the button below to retry", onRetryClicked: {})
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.canvas)
}
