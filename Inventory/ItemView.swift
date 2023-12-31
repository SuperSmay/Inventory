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
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.editMode) private var editMode
    
    @Bindable var item: InventoryItem
    
    @FocusState var descriptionFocused
    
    @State var newItemName = ""
    @State var moveSheetShowing = false
    @State var selection = Set<InventoryItem>()
    
    var body: some View {
    
        Form {
            
            Section("Details") {
                TextField("Name", text: $item.name)
                
                ImagePickerWindow(imageData: $item.imageData)
                
                TextField("Details", text: $item.notes, axis: .vertical)
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
        
            Section("Other items") {
                
                HStack {
                    
                    TextField("New item", text: $newItemName)
                    
                    Rectangle()
                        .frame(width: 1.5)
                        .foregroundStyle(.secondary)
                        .opacity(0.15)
                    
                    Button {
                        
                        guard newItemName != "" else { return }
                        
                        let newItem = InventoryItem(name: newItemName)
                        modelContext.insert(newItem)
                        item.subitems.append(newItem)
                        newItemName = ""
                        
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
        
                
                List(item.subitems, selection: $selection) { subitem in
                        
                    HStack {
                        if editMode?.wrappedValue == .active {
                            
                            Button {
                                withAnimation {
                                    if selection.contains(subitem) {
                                        selection.remove(subitem)
                                    } else {
                                        selection.insert(subitem)
                                    }
                                }
                                
                            } label: {
                                if selection.contains(subitem) {
                                    Image(systemName: "checkmark.circle.fill")
                                } else {
                                    Image(systemName: "circle")
                                }
                            }
                        
                        }
                        
                        Text(subitem.name)
                        
                        NavigationLink(value: subitem) { } /// Empty nav link so that the text object doesn't get dimmed when the link is disabled
                            .disabled(editMode?.wrappedValue == .active)
                    }
                    
                }
                
            }
        }
        .overlay(alignment: .bottom) {
            if editMode?.wrappedValue == .active && selection.count > 0 {
                Button {
                    
                } label: {
                    Label("Move Items", systemImage: "arrow.forward.square")
                        .font(.title3)
                        .bold()
                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding()
                .buttonStyle(.borderedProminent)
                .ignoresSafeArea()
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                
            }
        }
        .sheet(isPresented: $moveSheetShowing) {
            
        }
        .toolbar {
            Button {
                withAnimation {
                    if editMode?.wrappedValue == .active {
                        editMode?.wrappedValue = .inactive
                    } else {
                        editMode?.wrappedValue = .active
                    }
                }
            } label: {
                Text(editMode?.wrappedValue == .active ? "Done" : "Edit")
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
        let newItem = InventoryItem(name: "test")
        container.mainContext.insert(newItem)
        example.subitems.append(newItem)
        
        return NavigationStack {
            ItemView(item: example)
                .modelContainer(container)
                .navigationDestination(for: InventoryItem.self) { item in
                    ItemView(item: item)
                }
                .onAppear {
                    
                }
        }
    } catch {
        fatalError("Failed to create model")
    }
    
    
}
