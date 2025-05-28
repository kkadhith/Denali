//
//  DenaliApp.swift
//  Denali
//
//  Created by Adhith Karthikeyan on 2/20/25.
//  Licensed under Apache License v2.0
//

import SwiftUI

@main
struct DenaliApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
