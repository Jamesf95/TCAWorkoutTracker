import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ExericiseListPage(
                store: Store(initialState: AppFeature.AppState.initial) {
                    AppFeature()
                }
            )
        }
    }
}
