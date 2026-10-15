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
                let initialWorkoutState = WorkoutFeature.State(exercises: state.home.selectedExercises)
                state.path.append(.workout(initialWorkoutState))
                return .none

            case .home, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
}
