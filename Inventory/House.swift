//
//  House.swift
//  Inventory
//
//  Created by Smay on 12/14/23.
//

import Foundation
import SwiftData

@Model
class House {
    var name: String
    var address: String
    var storedItems: [InventoryItem]
    var uuid: UUID
    @Attribute(.externalStorage) var imageData: Data?
    
    /// Dates
    var dateEdited: Date
    var dateCreated: Date
    
    init(name: String, address: String = "", storedItems: [InventoryItem] = [], imageData: Data? = nil) {
        self.name = name
        self.address = address
        self.storedItems = storedItems
        self.imageData = imageData
        self.dateEdited = .now
        self.dateCreated = .now
        self.uuid = UUID()
    }
}
