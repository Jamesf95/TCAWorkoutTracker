import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                let exercises = try! ExerciseStore()
                    .fetchAll()
                print(exercises)
            }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
