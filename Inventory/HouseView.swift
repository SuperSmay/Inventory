//
//  HouseView.swift
//  Inventory
//
//  Created by Smay on 12/14/23.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct HouseView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Bindable var house: House
    
    @State var itemDisplayStack = [InventoryItem]()
    
    var body: some View {
        Form {
                Section("Details") {
                    
                    TextField("Name", text: $house.name)
                    
                    ImagePickerWindow(imageData: $house.imageData)
                    
                }
                
                Section("Rooms") {
                    ForEach(house.storedItems) { item in
                        NavigationLink(value: item) {
                            Text(item.name)
                        }
                    }
                    
                    Button("Add") {
                        let newItem = InventoryItem()
                        house.storedItems.append(newItem)
                    }
                }
            
        }
    }

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: House.self, configurations: config)
        
        let example = House(name: "Home", address: "142 Fellowship Drive", storedItems: [])
        
        return HouseView(house: example)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create preview")
    }
}
