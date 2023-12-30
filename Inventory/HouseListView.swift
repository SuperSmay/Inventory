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
            // TODO: change number of items in row dynamically
            let rowLength = 2
            let gridItemWidth = 175
            Grid(alignment: .top) {
                
                let rowRange = Array(0..<houses.count/rowLength+1)
                
                ForEach(rowRange, id: \.self) { rowIndex in
                    
                    let columnRange = Array(0..<rowLength)
                    
                    GridRow {
                        
                        ForEach(columnRange, id: \.self) { columnIndex in
                            
                            let indexInList = rowIndex * rowLength + columnIndex
                            
                            if indexInList < houses.count {
                                
                                let house = houses[indexInList]
                                
                                NavigationLink(value: house) {
                                    HouseGridItemView(house: house, gridItemWidth: CGFloat(gridItemWidth))
                                }
                            }
                        }
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
            
            Spacer()
        }
    }
}

struct HouseGridItemView: View {
    
    let house: House
    let gridItemWidth: CGFloat
    
    var body: some View {
        Text(house.name)
            .font(.title2)
            .bold()
            .padding()
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            .frame(width: gridItemWidth, height: 100)
            .background {
                Rectangle()
                    .foregroundStyle(.secondary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: House.self, configurations: config)
        
        let example = House(name: "Home Sweet Home", address: "142 Fellowship Drive", storedItems: [])
        let example2 = House(name: "Home Sweet Home 2", address: "142 Fellowship Drive", storedItems: [])
        let example3 = House(name: "Home Sweet Home 3", address: "142 Fellowship Drive", storedItems: [])
        
        return HouseListView(houses: [example, example2, example3, example3, example3, example3])
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create preview")
    }
}
