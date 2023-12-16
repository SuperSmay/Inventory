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
    
    @State var newRoomName = ""
    
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
                    
                    HStack {
                        
                        TextField("New item", text: $newRoomName)
                        
                        Rectangle()
                            .frame(width: 1.5)
                            .foregroundStyle(.secondary)
                            .opacity(0.15)
                        
                        Button {
                            
                            guard newRoomName != "" else { return }
                            
                            let newItem = InventoryItem(name: newRoomName)
                            house.storedItems.append(newItem)
                            newRoomName = ""
                            
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        
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
