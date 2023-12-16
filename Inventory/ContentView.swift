//
//  ContentView.swift
//  Inventory
//
//  Created by Smay on 5/9/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var houses: [House]
    
    var body: some View {
        HouseListView(houses: houses)   
    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
