//
//  CoreDataExplorationApp.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/21/23.
//

import SwiftUI

@main
struct CoreDataExplorationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
