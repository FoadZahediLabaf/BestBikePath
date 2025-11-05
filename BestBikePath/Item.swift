//
//  Item.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
