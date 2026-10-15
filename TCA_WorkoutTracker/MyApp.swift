import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            RootPage(
                store: Store(initialState: RootFeature.State()) {
                    RootFeature()
                }
            )
            .font(AppTypography.body)
        }
    }
}
