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
    
    @Binding var itemDisplayStack: [InventoryItem]
    @Bindable var item: InventoryItem
    
    @FocusState var descriptionFocused
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingImagePicker = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                TextField("Name", text: $item.name)
                    .padding()
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding()
                
                
                
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
                    .padding()
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding()
                     
                Form {
                    ForEach(item.subitems) { subitem in
                        
                        NavigationLink(subitem.name, destination: ItemView(itemDisplayStack: $itemDisplayStack, item: subitem))

                    }
                }
                
                Button {

                    let newItem = InventoryItem(name: "New")
                    item.subitems.append(newItem)
                    
                } label: {
                    Label("Add", systemImage: "plus")
                }
                
            }
            .navigationTitle(Text(item.name))
        }
    }
    
    func loadImage() {
        
    }
    
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: InventoryItem.self, configurations: config)
        
        let example = InventoryItem()
        
        return ItemView(itemDisplayStack: Binding.constant([]), item: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model")
    }
    
    
}
