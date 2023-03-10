//
//  TheComposableArchitectureApp.swift
//  TheComposableArchitecture
//
//  Created by 이건우 on 2023/02/04.
//

import SwiftUI
import ComposableArchitecture

@main
struct TheComposableArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView(store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: ()
            ))
            .sheet(isPresented: .constant(false)) {
                // TODO: Add todo view
            }
        }
    }
}
