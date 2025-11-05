//
//  PlantReminderModel.swift
//  Planto1
//
//  Created by Fajer saleh on 14/05/1447 AH.
//

import Foundation

// MARK: - Plant Reminder Model
struct PlantReminder: Identifiable, Codable {
    let id: UUID
    var plantName: String
    var room: String
    var lightCondition: String
    var waterAmount: String
    var isChecked: Bool
    
    init(id: UUID = UUID(), plantName: String, room: String, lightCondition: String, waterAmount: String, isChecked: Bool = false) {
        self.id = id
        self.plantName = plantName
        self.room = room
        self.lightCondition = lightCondition
        self.waterAmount = waterAmount
        self.isChecked = isChecked
    }
}
