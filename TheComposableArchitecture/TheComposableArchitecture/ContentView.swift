import SwiftUI
import ComposableArchitecture

// MARK: - Domain

struct AppState: Equatable {
    var todos: [Todo] = []
    var newTodoTitle = ""
}

enum AppAction {
    case todoToggled(Int)
    case delete(IndexSet)
}

struct Todo: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var completed: Bool = false
}

// MARK: - Reducers
let appReducer = AnyReducer<AppState, AppAction, Void> { state, action, _ in
    switch action {
    case let .todoToggled(index):
        state.todos[index].completed.toggle()
        return .none

    case let .delete(indexSet):
        state.todos.remove(atOffsets: indexSet)
        return .none
    }
}

// MARK: - Views
struct TodoListView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.todos) { todo in
                        Button {
                            viewStore.send(.todoToggled(todoIndex(for: todo, in: viewStore.todos)))
                        } label: {
                            HStack {
                                Image(systemName: todo.completed ? "checkmark.square" : "square")
                                Text(todo.title)
                            }
                        }
                        .foregroundColor(todo.completed ? .gray : .primary)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationTitle("Todo List")
                .navigationBarItems(trailing:
                    Button("Add") {
                        print("Add new todo")
                    }
                )
            }
        }
    }

    private func todoIndex(for todo: Todo, in todos: [Todo]) -> Int {
        todos.firstIndex(where: { $0.id == todo.id })!
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(store: Store(
            initialState: AppState(
                todos: [
                    Todo(title: "Buy milk"),
                    Todo(title: "Take out the trash"),
                    Todo(title: "Do laundry")
                ]
            ),
            reducer: appReducer,
            environment: ()
        ))
    }
}
