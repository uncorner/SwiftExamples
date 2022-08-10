//
//  MovieBoosterApp.swift
//  MovieBooster
//
//  Created by denis on 03.08.2022.
//

import SwiftUI

@main
struct MovieBoosterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            // fix some warning
            .navigationViewStyle(.stack)
        }
    }
}
