import Testing
@testable import TCA_WorkoutTracker
import ComposableArchitecture

@MainActor
@Suite
struct WorkoutFeatureTests {

    @Test
    func bindingSetMetricsUpdatesStateAndValidation() async {
        let store = TestStore(
            initialState: WorkoutFeature.State(exercises: [makeExercise(name: "Squat", muscle: .quadriceps)])
        ) {
            WorkoutFeature()
        }

        #expect(!store.state.canCompleteSet)

        await store.send(.binding(.set(\.reps, "10"))) {
            $0.reps = "10"
        }
        await store.send(.binding(.set(\.weight, "0"))) {
            $0.weight = "0"
        }

        #expect(store.state.canCompleteSet)

        await store.send(.binding(.set(\.reps, "0"))) {
            $0.reps = "0"
        }

        #expect(!store.state.canCompleteSet)
    }

    @Test
    func completingExerciseAdvancesThroughWorkoutQueue() async {
        let exercises = [
            makeExercise(name: "Squat", muscle: .quadriceps),
            makeExercise(name: "Bench press", muscle: .chest)
        ]
        let store = TestStore(
            initialState: WorkoutFeature.State(exercises: exercises)
        ) {
            WorkoutFeature()
        }

        #expect(store.state.currentExercise == exercises[0])
        #expect(store.state.upNextExercises == [exercises[1]])

        await store.send(.completeExerciseTapped) {
            $0.currentExerciseIndex = 1
        }

        #expect(store.state.currentExercise == exercises[1])
        #expect(store.state.completedExercises == [exercises[0]])
        #expect(store.state.upNextExercises.isEmpty)

        await store.send(.completeExerciseTapped) {
            $0.currentExerciseIndex = 2
        }

        #expect(store.state.currentExercise == nil)
        #expect(store.state.completedExercises == exercises)
        #expect(store.state.upNextExercises.isEmpty)

        await store.send(.completeExerciseTapped)
    }
}

private func makeExercise(name: String, muscle: Muscle) -> Exercise {
    Exercise(
        name: name,
        primaryMuscles: [muscle],
        secondaryMuscles: [],
        category: .strength,
        instructions: []
    )
}
