import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ExericiseListPage(
                store: Store(initialState: AppFeature.State.initial) {
                    AppFeature()
                }
            )
            .font(AppTypography.body)
        }
    }
}
