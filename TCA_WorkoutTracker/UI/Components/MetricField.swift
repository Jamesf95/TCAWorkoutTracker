//
//  MetricField.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI

struct MetricField: View {
    
    enum FieldType {
        case weight
        case reps
    }

    let title: String
    @Binding var value: String
    let fieldType: FieldType
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(AppTypography.overline)
                .foregroundStyle(AppColor.textOnDarkMuted)
                .tracking(1.2)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                TextField("0", text: $value)
                    .font(AppTypography.metric)
                    .foregroundStyle(.white)
                    .keyboardType(fieldType.keyboardType)
                    .multilineTextAlignment(.leading)
                    .submitLabel(.done)
                    .focused($isFocused)
                    .onSubmit {
                        isFocused = false
                    }
                    .accessibilityLabel(title.capitalized)

                Spacer(minLength: 4)

                Text(fieldType.unit)
                    .font(AppTypography.overline)
                    .foregroundStyle(AppColor.textOnDarkMuted)
            }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 12)
        .background(AppColor.darkInput)
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isFocused ? AppColor.focusBorder : AppColor.darkInputBorder,
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}

extension MetricField.FieldType {
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .reps: return .numberPad
        case .weight: return .decimalPad
        }
    }
    
    var unit: String {
        switch self {
        case .reps: return "Reps"
        case .weight: return "kg"
        }
    }
    
}


#Preview {
    MetricField(title: "Reps", value: .constant("1"), fieldType: .reps)
}
