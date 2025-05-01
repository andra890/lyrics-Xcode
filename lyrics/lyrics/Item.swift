//
//  Item.swift
//  lyrics
//
//  Created by MacBook on 22/04/25.
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
