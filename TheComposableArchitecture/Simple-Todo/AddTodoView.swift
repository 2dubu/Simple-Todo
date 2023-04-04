import SwiftUI
import ComposableArchitecture

struct AddTodoView: View {
    
    @Environment(\.presentationMode) var presentationmode
    @State private var todoContent: String = .init()
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 20) {
                Text("Add a new Todo!")
                    .font(.headline)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.leading, 40)
                
                TextField("ex) Buy milk, Do laundry ...", text: $todoContent)
                    .textFieldStyle(TodoInputTextField())
                    .frame(width: UIScreen.main.bounds.width - 30)
                
                Button {
                    viewStore.send(.add(todoContent))
                    presentationmode.wrappedValue.dismiss()
                } label: {
                    Text("Add")
                        .font(.system(size: 15))
                }
                .buttonStyle(AddTodoButton())
            }
        }
    }
}

struct TodoInputTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 15))
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(
                Color(UIColor.systemGray6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .autocorrectionDisabled()
    }
}

struct AddTodoButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color(UIColor.systemIndigo))
            .foregroundColor(.white)
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            .padding(.trailing, 32)
    }
}
