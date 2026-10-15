import ComposableArchitecture

@Reducer
struct WorkoutFeature {

    @ObservableState
    struct State: Equatable {
        let exercises: [Exercise]
    }

    enum Action {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { _, _ in
            .none
        }
    }
}
