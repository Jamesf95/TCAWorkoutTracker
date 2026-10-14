//
//  AppFeature.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 13/10/2026.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var exerciseList: [Exercise]
        var isLoading: Bool
        var error: AppError?
    }
    
    enum Action {
        case initialLoad
        case retryPressed
        case exerciseListLoaded([Exercise])
        case exerciseListFailed(AppError)
    }
    
    enum AppError: Equatable {
        case loadError
    }
    
    @Dependency(\.appFeatureDependencies) var dependencies
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
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
                        let appError = parseAppError(from: error)
                        await send(.exerciseListFailed(appError))
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

extension AppFeature.State {
    
    static var initial: AppFeature.State {
        .init(exerciseList: [], isLoading: false, error: nil)
    }
    
}

private nonisolated func parseAppError(from cause: Error) -> AppFeature.AppError {
    // Custom error handling here. This is just a dummy example so
    // just returns a loadError
    return .loadError
}
