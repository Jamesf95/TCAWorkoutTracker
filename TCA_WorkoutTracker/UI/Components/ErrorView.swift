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
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 72, height: 72)
                .foregroundStyle(.orange)
            
            Spacer().frame(height: 8)
            
            Text(title)
                .font(.title2)
            
            if let subtitle {
                Text(subtitle)
                    .font(.body)
            }
            
            if let onRetryClicked {
                Spacer().frame(height: 8)
                
                Button(action: onRetryClicked) {
                    Text(retryLabel)
                        .fontWeight(.bold)
                        .frame(minWidth: 200)
                        .frame(minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                
            }
        }
    }
    
}

#Preview {
    ErrorView(subtitle: "Click the button below to retry", onRetryClicked: {})
}
