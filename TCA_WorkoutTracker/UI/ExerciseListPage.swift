//
//  ExerciseListPage.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 13/10/2026.
//

import SwiftUI
import ComposableArchitecture

struct ExericiseListPage: View {
    let store: StoreOf<AppFeature>
 
    var body: some View {
        Group {
            if store.error != nil {
                ErrorView(title: "Error fetching exercises", onRetryClicked: {
                    store.send(.retryPressed)
                })
            
            } else if store.isLoading {
                ProgressView("Loading")
            
            } else if store.exerciseList.isEmpty {
                ErrorView(title: "Exercises failed to load")
            
            } else {
                ExerciseListView(exercises: store.exerciseList)
            }
        }.onAppear {
           store.send(.initialLoad)
        }
    }
}


struct ExerciseListView: View {
    let exercises: [Exercise]
    
    var body: some View {
        List(exercises) { exercise in
            Text(exercise.name)
        }
    }
}
