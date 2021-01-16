//
//  PRLogApp.swift
//  PRLog
//
//  Created by Allen Davis-Swing on 11/27/20.
//

import SwiftUI

@main
struct PRLogApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
