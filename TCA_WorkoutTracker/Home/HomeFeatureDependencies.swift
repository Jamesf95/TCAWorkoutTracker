//
//  HomeFeatureDependencies.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 14/10/2026.
//

import ComposableArchitecture

struct HomeFeatureDependencies {
    var fetchExercises: () async throws -> [Exercise]
}

extension HomeFeatureDependencies: DependencyKey {

    static let liveValue: HomeFeatureDependencies = Self(
        fetchExercises: ExerciseStore().fetchAll
    )
}

extension DependencyValues {

    var homeFeatureDependencies: HomeFeatureDependencies {
        get { self[HomeFeatureDependencies.self] }
        set { self[HomeFeatureDependencies.self] = newValue }
    }
}
