//
//  AppFeatureTests.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 14/10/2026.
//

import Testing
@testable import TCA_WorkoutTracker
import ComposableArchitecture

@MainActor
@Suite
struct AppFeatureTests {

    @Test
    func initialLoadSuccess() async {
        let store = TestStore(initialState: .initial) {
            AppFeature()
        } withDependencies: {
            $0.appFeatureDependencies.fetchExercises = { mockExercises }
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
        let expectedError = ExerciseStoreError.jsonParsingFailed

        let store = TestStore(initialState: .initial) {
            AppFeature()
        } withDependencies: {
            $0.appFeatureDependencies.fetchExercises = { throw expectedError }
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
    func retryPressedClearsErrorAndSucceeds() async {
        let initialState = AppFeature.State(
            exerciseList: [],
            isLoading: false,
            error: .jsonParsingFailed
        )

        let store = TestStore(initialState: initialState) {
            AppFeature()
        } withDependencies: {
            $0.appFeatureDependencies.fetchExercises = { mockExercises }
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

