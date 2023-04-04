import SwiftUI
import ComposableArchitecture

@main
struct SimpleTodoApp: App {
    let todoStore = Store(
        initialState: AppState(todos: [
            Todo(title: "Buy pizza"),
            Todo(title: "Take out the trash")
        ]),
        reducer: appReducer,
        environment: ()
    )
    
    var body: some Scene {
        WindowGroup {
            TodoListView(store: todoStore)
        }
    }
}
