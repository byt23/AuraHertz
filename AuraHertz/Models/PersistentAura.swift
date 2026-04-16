//
//  PersistentAura.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import Foundation
import SwiftData

@Model
class PersistentAura {
    var id: UUID
    var date: Date
    var moodDescription: String
    var hue: Double
    var frequency: Double
    var score: Int
    
    init(moodDescription: String, hue: Double, frequency: Double, score: Int) {
        self.id = UUID()
        self.date = Date()
        self.moodDescription = moodDescription
        self.hue = hue
        self.frequency = frequency
        self.score = score
    }
}
