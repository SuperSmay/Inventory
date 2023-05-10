//
//  ContentView.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isTopLevel == TRUE")) private var rooms: FetchedResults<Item>
    
    @State private var itemDisplayStack = [Item]()
    
    var body: some View {
        NavigationStack(path: $itemDisplayStack) {
            
            VStack {
                Form {
                    ForEach(rooms) { item in
                        NavigationLink(item.name ?? "Unnamed item", value: item)
                    }
                }
                .navigationDestination(for: Item.self) { item in
                    ItemView(itemDisplayStack: $itemDisplayStack, item: item)
                }
                
                Button {
                    let newItem = Item(context: moc)
                    newItem.isTopLevel = true
                    newItem.id = UUID()
                    
                    do {
                        try moc.save()
                        itemDisplayStack.append(newItem)
                    } catch {
                        print(error)
                    }
                    
                    
                } label: {
                    Label("Add", systemImage: "plus")
                }
                
            }
            .navigationTitle("Inventory")
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
