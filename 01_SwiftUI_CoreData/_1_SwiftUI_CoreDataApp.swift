//
//  _1_SwiftUI_CoreDataApp.swift
//  01_SwiftUI_CoreData
//
//  Created by webwerks  on 15/11/23.
//

import SwiftUI

@main
struct _1_SwiftUI_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
