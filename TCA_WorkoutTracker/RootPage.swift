import ComposableArchitecture
import SwiftUI

struct RootPage: View {
    @Bindable var store: StoreOf<RootFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomePage(
                store: store.scope(state: \.home, action: \.home)
            )
        } destination: { store in
            switch store.case {
            case let .workout(workoutStore):
                WorkoutPage(store: workoutStore)
            }
        }
    }
}
