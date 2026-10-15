//
//  HomeFeature.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 13/10/2026.
//

import ComposableArchitecture

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State: Equatable {
        var exerciseList: [Exercise]
        var isLoading: Bool
        var error: HomeError?
    }
    
    enum Action {
        case startWorkoutTapped
        case initialLoad
        case retryPressed
        case exerciseListLoaded([Exercise])
        case exerciseListFailed(HomeError)
    }
    
    enum HomeError: Equatable {
        case loadError
    }
    
    @Dependency(\.homeFeatureDependencies) var dependencies
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .startWorkoutTapped:
                return .none
            
            case .retryPressed: fallthrough
            case .initialLoad:
                state.error = nil
                state.exerciseList = []
                state.isLoading = true
                
                return .run { send in
                    // There's nothing here enforcing I return something
                    // possible to forget and do nothing?
                    do {
                        let list = try await dependencies.fetchExercises()
                        await send(.exerciseListLoaded(list))
                        
                    } catch {
                        let homeError = parseHomeError(from: error)
                        await send(.exerciseListFailed(homeError))
                    }
                }
                
            case .exerciseListLoaded(let exercises):
                state.isLoading = false
                state.error = nil
                state.exerciseList = exercises
                return .none
                
            case .exerciseListFailed(let error):
                state.isLoading = false
                state.error = error
                state.exerciseList = []
                return .none
                
            }
        }
    }
}

extension HomeFeature.State {
    
    static var initial: HomeFeature.State {
        .init(exerciseList: [], isLoading: false, error: nil)
    }
    
}

private nonisolated func parseHomeError(from cause: Error) -> HomeFeature.HomeError {
    // Custom error handling here. This is just a dummy example so
    // just returns a loadError
    return .loadError
}
