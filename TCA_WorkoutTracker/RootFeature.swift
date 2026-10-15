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
        var home = HomeFeature.State.initial
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
                state.path.append(.workout(WorkoutFeature.State()))
                return .none

            case .home, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
}
