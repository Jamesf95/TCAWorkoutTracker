//
//  HomeFeatureTests.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 14/10/2026.
//

import Testing
@testable import TCA_WorkoutTracker
import ComposableArchitecture

@MainActor
@Suite
struct HomeFeatureTests {

    @Test
    func initialLoadSuccess() async {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.homeFeatureDependencies.fetchExercises = { mockExercises }
        }

        await store.send(.initialLoad) {
            $0.isLoading = true
            $0.error = nil
            $0.exerciseList = []
        }

        await store.receive(\.exerciseListLoaded) {
            $0.isLoading = false
            $0.exerciseList = mockExercises
            $0.error = nil
        }
    }

    @Test
    func initialLoadFailure() async {
        let expectedError = HomeFeature.HomeError.loadError

        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.homeFeatureDependencies.fetchExercises = { throw ExerciseStoreError.jsonParsingFailed }
        }

        await store.send(.initialLoad) {
            $0.isLoading = true
            $0.error = nil
            $0.exerciseList = []
        }

        await store.receive(\.exerciseListFailed) {
            $0.isLoading = false
            $0.error = expectedError
            $0.exerciseList = []
        }
    }

    @Test
    func initialLoadWithEmptyResultClearsStaleState() async {
        let selectedExercises = [mockExercises[0]]
        let initialState = HomeFeature.State(
            exerciseList: mockExercises,
            selectedExercises: selectedExercises,
            error: .loadError
        )
        let store = TestStore(initialState: initialState) {
            HomeFeature()
        } withDependencies: {
            $0.homeFeatureDependencies.fetchExercises = { [] }
        }

        await store.send(.initialLoad) {
            $0.isLoading = true
            $0.error = nil
            $0.exerciseList = []
        }

        await store.receive(\.exerciseListLoaded) {
            $0.isLoading = false
            $0.exerciseList = []
            $0.error = nil
        }
    }

    @Test
    func retryPressedClearsErrorAndSucceeds() async {
        let initialState = HomeFeature.State(
            exerciseList: [],
            isLoading: false,
            error: .loadError
        )

        let store = TestStore(initialState: initialState) {
            HomeFeature()
        } withDependencies: {
            $0.homeFeatureDependencies.fetchExercises = { mockExercises }
        }

        await store.send(.retryPressed) {
            $0.isLoading = true
            $0.error = nil      // Verifies the error is wiped on retry
            $0.exerciseList = []
        }

        await store.receive(\.exerciseListLoaded) {
            $0.isLoading = false
            $0.exerciseList = mockExercises
            $0.error = nil
        }
    }

    @Test
    func retryPressedFailureSetsErrorAndKeepsSelectedExercises() async {
        let selectedExercises = [mockExercises[0]]
        let initialState = HomeFeature.State(
            exerciseList: mockExercises,
            selectedExercises: selectedExercises,
            error: .loadError
        )
        let store = TestStore(initialState: initialState) {
            HomeFeature()
        } withDependencies: {
            $0.homeFeatureDependencies.fetchExercises = {
                throw ExerciseStoreError.jsonParsingFailed
            }
        }

        await store.send(.retryPressed) {
            $0.isLoading = true
            $0.error = nil
            $0.exerciseList = []
        }

        await store.receive(\.exerciseListFailed) {
            $0.isLoading = false
            $0.error = .loadError
            $0.exerciseList = []
        }
    }

    @Test
    func startWorkoutTappedDoesNotChangeState() async {
        let initialState = HomeFeature.State(
            exerciseList: mockExercises,
            selectedExercises: [mockExercises[0]]
        )
        let store = TestStore(initialState: initialState) {
            HomeFeature()
        }

        await store.send(.startWorkoutTapped)
    }
}


private let mockExercises: [Exercise] = [
    Exercise(
        name: "Barbell Bench Press",
        aliases: ["Bench Press"],
        primaryMuscles: [.chest],
        secondaryMuscles: [.triceps, .shoulders],
        equipment: .barbell,
        category: .strength,
        instructions: [
            "Lie on the bench with your eyes under the bar.",
            "Grip the bar slightly wider than shoulder-width.",
            "Unrack the bar, lower it to your mid-chest, and press back up."
        ],
        description: "A classic compound upper body movement.",
        tips: ["Keep your feet flat on the floor.", "Maintain a slight arch in your lower back."]
    ),
    Exercise(
        name: "Barbell Squat",
        aliases: ["Back Squat"],
        primaryMuscles: [.quadriceps, .glutes],
        secondaryMuscles: [.hamstrings, .lowerBack],
        equipment: .barbell,
        category: .strength,
        instructions: [
            "Position the bar across your upper back/traps.",
            "Unrack, step back, and set your stance shoulder-width apart.",
            "Initiate the descent by pushing your hips back and bending your knees.",
            "Squat down until thighs are parallel to the floor, then drive back up."
        ],
        description: "The king of lower body compound exercises.",
        tips: ["Keep your chest up and core braced.", "Ensure knees track over your toes."]
    ),
    Exercise(
        name: "Pull-up",
        aliases: ["Overhand Pullup"],
        primaryMuscles: [.lats],
        secondaryMuscles: [.biceps, .middleBack],
        equipment: .body,
        category: .strength,
        instructions: [
            "Grab the pull-up bar with an overhand grip wider than shoulder-width.",
            "Hang with arms fully extended.",
            "Pull yourself up until your chin clears the bar, then lower down with control."
        ],
        description: "An exceptional bodyweight movement for back development.",
        tips: ["Avoid swinging or using momentum.", "Drive your elbows down toward the floor."]
    )
]
