//
//  WorkoutPage.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI
import ComposableArchitecture

struct WorkoutPage: View {

    let store: StoreOf<WorkoutFeature>

    var body: some View {
        WorkoutPageContent()
    }
}

private struct WorkoutPageContent: View {
    @FocusState private var focusedField: MetricField.FieldType?

    var body: some View {
        VStack {
            CurrentSetCard(focusedField: $focusedField)
        }
        .navigationTitle("Active workout")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(AppColor.inkOnDark)
        .padding(16)
        .background(AppColors.canvas.ignoresSafeArea())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
    
}

private struct CurrentSetCard: View {
    @State var repsEntry = ""
    @State var weightEntry = ""
    let focusedField: FocusState<MetricField.FieldType?>.Binding
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Set")
                .font(AppTypography.caption)
            
            HStack(alignment: .bottom) {
                Text("1 of 3")
                    .font(AppTypography.cardTitle)
            }
            
            HStack {
                MetricField(
                    title: "Reps",
                    value: $repsEntry,
                    fieldType: .reps,
                    focusedField: focusedField
                )
                
                MetricField(
                    title: "Weight",
                    value: $weightEntry,
                    fieldType: .weight,
                    focusedField: focusedField
                )
            }
            
            HStack {
                Spacer()
                
                LimeButton(title: "Complete", action: {
                    // TODO
                }, isDisabled: !hasValidMetrics)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(AppColor.inkOnDark)
        .padding(16)
        .background(AppColors.darkCard, in: RoundedRectangle(cornerRadius: 12))
       
        
    }

    private var hasValidMetrics: Bool {
        guard let reps = Int(repsEntry), reps > 0,
              let weight = Decimal(string: weightEntry, locale: .current)
        else {
            return false
        }

        return weight >= 0
    }
}

#Preview {
    NavigationStack {
        WorkoutPageContent()
    }
}
