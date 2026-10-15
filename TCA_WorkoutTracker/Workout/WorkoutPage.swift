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
    
    var body: some View {
        VStack {
            CurrentSetCard()
        }
        .navigationTitle("Active workout")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(AppColor.inkOnDark)
        .padding(16)
        .background(AppColors.canvas)
    }
    
}

private struct CurrentSetCard: View {
    @State var repsEntry = ""
    @State var weightEntry = ""
    
    var body: some View {
        HStack {
         
            MetricField(title: "Reps", value: $repsEntry, fieldType: .reps)
        
            MetricField(title: "Weight", value: $weightEntry, fieldType: .weight)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(AppColor.inkOnDark)
        .padding(16)
        .background(AppColors.darkCard, in: RoundedRectangle(cornerRadius: 12))
       
        
    }
}

#Preview {
    NavigationStack {
        WorkoutPageContent()
    }
}
