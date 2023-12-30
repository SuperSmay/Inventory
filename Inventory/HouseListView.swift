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
    @AppStorage("lastOpenedHouse") var lastOpenedHouseID: String = ""
    
    var body: some View {
        NavigationStack(path: $houseDisplayStack) {

            ScrollView {
                VStack {
                    ForEach(houses) { house in
                        NavigationLink(value: house) {
                            HouseGridItemView(house: house)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
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
               
            }
            .navigationDestination(for: InventoryItem.self) { item in
                ItemView(item: item)
            }
            .navigationDestination(for: House.self) { house in
                HouseView(house: house)
            }
            .navigationTitle("Locations")
            .background {
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundStyle(.ultraThickMaterial)
                    
            }
            
        }
        .onAppear() {
            for house in houses {
                if house.uuid.uuidString == lastOpenedHouseID {
                    houseDisplayStack.append(house)
                }
            }
        }
        
        
        
    }
}

struct HouseGridItemView: View {
    
    let house: House
    
    var body: some View {
        Grid {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(house.name)
                        .font(.title3)
                        .bold()
                    
                    if !house.address.isEmpty {
                        Text(house.address)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            
            Divider()
            
            if let image = UIImage(data: house.imageData ?? Data()) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            } else {
                Image(systemName: "house")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    
            }
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 200)
        .padding()
        .background {
            Rectangle()
                .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: House.self, configurations: config)
        
        let example = House(name: "Home Sweet Home", address: "142 Fellowship Drive", storedItems: [])
        let example2 = House(name: "Home Sweet Home 2", storedItems: [])
        let example3 = House(name: "Home Sweet Home Sweet Home Sweet Home Sweet Home Sweet Home Sweet Home ", address: "This is a really really stupid long address it just keeps going", storedItems: [])
        
        return HouseListView(houses: [example, example2, example3])
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create preview")
    }
}
