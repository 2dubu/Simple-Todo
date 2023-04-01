import SwiftUI
import ComposableArchitecture

// MARK: - Domain
struct Todo: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var completed: Bool = false
}

typealias Todos = [Todo]

struct AppState: Equatable {
    var todos: Todos = .init()
}

enum AppAction {
    case add(String)
    case todoToggled(Int)
    case delete(IndexSet)
}

// MARK: - Reducers
let appReducer = AnyReducer<AppState, AppAction, Void> { state, action, _ in
    switch action {
    case let .add(content):
        state.todos.append(Todo(title: content))
        return .none
        
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
    @State private var showingSheet: Bool = false
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
                    Button {
                        showingSheet = true
                    } label: {
                        Text("Add")
                    }
                )
                .overlay {
                    if viewStore.state.todos.isEmpty {
                        Text("There's no todo!\nPress the Add button to add new todo")
                            .multilineTextAlignment(.center)
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    AddTodoView(store: store)
                        .presentationDetents([.height(195)])
                        .presentationDragIndicator(.hidden)
                }
            }
        }
    }

    private func todoIndex(for todo: Todo, in todos: [Todo]) -> Int {
        todos.firstIndex(where: { $0.id == todo.id })!
    }
}
