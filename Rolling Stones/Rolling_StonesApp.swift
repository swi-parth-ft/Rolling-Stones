//
//  Rolling_StonesApp.swift
//  Rolling Stones
//
//  Created by Parth Antala on 2024-07-22.
//
import SwiftData
import SwiftUI

@main
struct Rolling_StonesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: History.self)
    }
}
