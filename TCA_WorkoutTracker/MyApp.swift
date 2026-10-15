import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            HomePage(store: Store(initialState: HomeFeature.State.initial) {
                HomeFeature()
            })
            .font(AppTypography.body)
        }
    }
}
