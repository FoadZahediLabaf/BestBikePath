//
//  BestBikePathApp.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import SwiftUI
import SwiftData

@main
struct BestBikePathApp: App {

    @State private var appModel = BestBikePathModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(appModel.sharedModelContainer)
        .environment(appModel)
    }
}
