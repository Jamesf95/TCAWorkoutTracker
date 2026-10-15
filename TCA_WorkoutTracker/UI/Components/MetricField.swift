//
//  MetricField.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI

struct MetricField: View {
    
    enum FieldType: Hashable {
        case weight
        case reps
    }

    let title: String
    @Binding var value: String
    let fieldType: FieldType
    let focusedField: FocusState<FieldType?>.Binding
    
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
                    .focused(focusedField, equals: fieldType)
                    .onSubmit {
                        focusedField.wrappedValue = nil
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
                    focusedField.wrappedValue == fieldType
                        ? AppColor.focusBorder
                        : AppColor.darkInputBorder,
                    lineWidth: focusedField.wrappedValue == fieldType ? 1.5 : 1
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .animation(.easeOut(duration: 0.15), value: focusedField.wrappedValue)
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
    MetricFieldPreview()
}

private struct MetricFieldPreview: View {
    @State private var value = "1"
    @FocusState private var focusedField: MetricField.FieldType?

    var body: some View {
        MetricField(
            title: "Reps",
            value: $value,
            fieldType: .reps,
            focusedField: $focusedField
        )
        .padding()
        .background(AppColor.darkCard)
    }
}
