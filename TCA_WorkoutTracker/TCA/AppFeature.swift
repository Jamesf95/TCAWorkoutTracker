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
    struct AppState: Equatable {
        var exerciseList: [Exercise]
        var isLoading: Bool
        var error: ExerciseStoreError?
    }
    
    enum AppAction {
        case initialLoad
        case retryPressed
        case exerciseListLoaded([Exercise])
        case exerciseListFailed(ExerciseStoreError)
    }
    
    var body: some Reducer<AppState, AppAction> {
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
                        // TODO: Dependencies.
                        let list = try await ExerciseStore().fetchAll()
                        await send(.exerciseListLoaded(list))
                        
                    } catch let error as ExerciseStoreError {
                        await send(.exerciseListFailed(error))
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

extension AppFeature.AppState {
    
    static var initial: AppFeature.AppState {
        .init(exerciseList: [], isLoading: false, error: nil)
    }
    
}
