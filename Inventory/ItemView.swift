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
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingImagePicker = false
    
    var body: some View {
        
        Form {
                
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
                 
            ForEach(item.subitems) { subitem in
                    
                NavigationLink(value: subitem) {
                    Text(subitem.name)
                }

            }
        
            Button {

                let newItem = InventoryItem(name: "New")
                print(newItem.name)
                item.subitems.append(newItem)
                
            } label: {
                Label("Add", systemImage: "plus")
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
