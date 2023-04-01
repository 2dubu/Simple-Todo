import SwiftUI
import ComposableArchitecture

@main
struct TheComposableArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView(store: Store(
                initialState: AppState(todos: [
                    Todo(title: "Buy pizza"),
                    Todo(title: "Take out the trash")
                ]),
                reducer: appReducer,
                environment: ()
            ))
        }
    }
}
