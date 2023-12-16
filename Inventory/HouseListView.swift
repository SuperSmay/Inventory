//
//  HouseListView.swift
//  Inventory
//
//  Created by Smay on 12/14/23.
//

import SwiftUI
import SwiftData

struct HouseListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    var houses: [House]
    @State private var houseDisplayStack = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $houseDisplayStack) {
            Form {
                ForEach(houses) { house in
                    NavigationLink(value: house) {
                        Text(house.name)
                    }
                    
                    
                }
            }
            .toolbar {
                Button {
                    let newHouse = House(name: "Home")
                    modelContext.insert(newHouse)
                    houseDisplayStack.append(newHouse)
                    
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationDestination(for: InventoryItem.self) { item in
                ItemView(item: item)
            }
            .navigationDestination(for: House.self) { house in
                HouseView(house: house)
            }
            .navigationTitle("Inventory")
        }
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: House.self, configurations: config)
        
        let example = House(name: "Home Sweet Home", address: "142 Fellowship Drive", storedItems: [])
        
        return HouseListView(houses: [example])
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create preview")
    }
}
