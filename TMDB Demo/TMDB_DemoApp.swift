//
//  TMDB_DemoApp.swift
//  TMDB Demo
//
//  Created by Naga on 10/05/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TMDB_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppFeature.State(), reducer: {
                AppFeature()
            }))
        }
    }
}
