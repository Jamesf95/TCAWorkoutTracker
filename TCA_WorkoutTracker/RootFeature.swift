//
//  RootFeature.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State {
        var home = HomeFeature.State()
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action {
        case home(HomeFeature.Action)
        case path(StackActionOf<Path>)
    }

    @Reducer
    enum Path {
        case workout(WorkoutFeature)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home(.startWorkoutTapped):
                // TODO: Preserve order of selected exercises.
                // IOts using a Set of exercises at the moment so order is lost. Better
                // to use an array and manually check for duplicates.
                let exercises = state.home.selectedExercises.map { $0 }
                let initialWorkoutState = WorkoutFeature.State(exercises: exercises)
                state.path.append(.workout(initialWorkoutState))
                return .none

            case .home, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
}
