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
        Text("Exercise List Page. Loading: \(store.isLoading). Error: \(store.error?.localizedDescription). List: \(store.exerciseList.count)")
            .onAppear {
                store.send(.initialLoad)
            }
    }
}
