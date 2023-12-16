//
//  InventoryApp.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI
import SwiftData

@main
struct InventoryApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Something something SwiftData
                .modelContainer(for: House.self)
        }
    }
}
