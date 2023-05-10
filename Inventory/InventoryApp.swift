//
//  InventoryApp.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI

@main
struct InventoryApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
