import ComposableArchitecture
import Foundation

@Reducer
struct WorkoutFeature {

    @ObservableState
    struct State: Equatable {
        let exercises: [Exercise]
        var currentExerciseIndex = 0
        var reps = ""
        var weight = ""

        var currentExercise: Exercise? {
            exercises.indices.contains(currentExerciseIndex) ? exercises[currentExerciseIndex] : nil
        }

        var canCompleteSet: Bool {
            guard let reps = Int(reps), reps > 0,
                  let weight = Decimal(string: weight, locale: .current)
            else {
                return false
            }

            return weight >= 0
        }

        var completedExercises: [Exercise] {
            Array(exercises.prefix(currentExerciseIndex))
        }

        var upNextExercises: [Exercise] {
            guard currentExercise != nil else { return [] }
            return Array(exercises.dropFirst(currentExerciseIndex + 1))
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case completeExerciseTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .completeExerciseTapped:
                guard state.currentExercise != nil else { return .none }
                state.currentExerciseIndex += 1
                return .none
            }
        }
    }
}
