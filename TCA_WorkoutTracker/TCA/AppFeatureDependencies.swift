//
//  AppFeatureDependencies.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 14/10/2026.
//

import ComposableArchitecture

struct AppFeatureDependencies {
    var fetchExercises: () async throws -> [Exercise]
}

extension AppFeatureDependencies: DependencyKey {
    
    static let liveValue: AppFeatureDependencies = Self(
        fetchExercises: ExerciseStore().fetchAll
    )
    
}

extension DependencyValues {
    
    var appFeatureDependencies: AppFeatureDependencies {
        get { self[AppFeatureDependencies.self] }
        set { self[AppFeatureDependencies.self] = newValue }
    }
    
}
