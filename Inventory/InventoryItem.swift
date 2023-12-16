//
//  InventoryItem.swift
//  Inventory
//
//  Created by Smay on 12/14/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class InventoryItem {
    var name: String
    var notes: String
    var subitems: [InventoryItem]
    @Attribute(.externalStorage) var imageData: Data?
    
    /// Dates
    var dateStored: Date
    var dateEdited: Date
    var dateCreated: Date
    
    init(name: String = "Unnamed Object", notes: String = "", subitems: [InventoryItem] = [], dateStored: Date = Date.now) {
        self.name = name
        self.notes = notes
        self.subitems = subitems
        self.dateStored = dateStored
        self.dateEdited = Date.now
        self.dateCreated = Date.now
    }
    
}
