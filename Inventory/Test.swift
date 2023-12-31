//
//  Test.swift
//  Inventory
//
//  Created by Smay on 12/30/23.
//

import SwiftUI

struct Test: View {
    @State private var selection = Set<String>()
    @Environment(\.editMode) private var editMode
    let names = [
        "Cyril",
        "Lana",
        "Mallory",
        "Sterling"
    ]

    var body: some View {
        NavigationStack {
            
            List(names, id: \.self) { name in
                HStack {
                    if editMode?.wrappedValue == .active {
                        Button {
                            if selection.contains(name) {
                                selection.remove(name)
                            } else {
                                selection.insert(name)
                            }
                            
                        }
                        label: {
                            if selection.contains(name) {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                    }
                    
                    Text(name)
                    
                }
            }
            .navigationTitle("List Selection")
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
        }
    }
}

#Preview {
    Test()
}
