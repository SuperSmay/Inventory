//
//  ItemView.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ItemView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var item: InventoryItem
    
    @FocusState var descriptionFocused
    
    @State var newItemName = ""
    
    var body: some View {
        
        Form {
                
            Section("Details") {
                TextField("Name", text: $item.name)
                
                ImagePickerWindow(imageData: $item.imageData)
                
                TextField("Description", text: $item.notes, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .focused($descriptionFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            
                            Spacer()
                            
                            Button("Done") {
                                descriptionFocused = false
                            }
                            
                        }
                    }
            }
            
            Section("Items Stored Here") {
                
                ForEach(item.subitems) { subitem in
                    
                    NavigationLink(value: subitem) {
                        Text(subitem.name)
                    }
                    
                }
                
                HStack {
                    
                    TextField("New item", text: $newItemName)
                    
                    Rectangle()
                        .frame(width: 1.5)
                        .foregroundStyle(.secondary)
                        .opacity(0.15)
                    
                    Button {
                        
                        guard newItemName != "" else { return }
                        
                        let newItem = InventoryItem(name: newItemName)
                        item.subitems.append(newItem)
                        newItemName = ""
                        
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    
                }
                
                
            }
        }
        .navigationTitle(Text(item.name))
                
    }
        
}


#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: InventoryItem.self, configurations: config)
        
        let example = InventoryItem()
        
        return ItemView(item: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model")
    }
    
    
}
