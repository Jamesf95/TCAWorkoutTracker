import ComposableArchitecture

@Reducer
struct WorkoutFeature {

    @ObservableState
    struct State: Equatable {}

    enum Action {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { _, _ in
            .none
        }
    }
}
