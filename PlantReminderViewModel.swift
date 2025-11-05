//
//  PlantReminderViewModel.swift
//  Planto1
//
//  Created by Fajer saleh on 14/05/1447 AH.
//

import Foundation
import SwiftUI
internal import Combine

// MARK: - Plant Reminder View Model
class PlantReminderViewModel: ObservableObject {
    @Published var plantReminders: [PlantReminder] = []
    
    var checkedCount: Int {
        plantReminders.filter { $0.isChecked }.count
    }
    
    var progressPercentage: Double {
        guard !plantReminders.isEmpty else { return 0 }
        return Double(checkedCount) / Double(plantReminders.count)
    }
    
    var hasPlants: Bool {
        !plantReminders.isEmpty
    }
    
    // MARK: - Add Plant with Notification
    func addPlant(_ plant: PlantReminder) {
        plantReminders.append(plant)
        savePlants()
        
        // Schedule notification for this plant
        NotificationManager.shared.scheduleReminderForPlant(plant)
    }
    
    // MARK: - Update Plant with Notification
    func updatePlant(_ plant: PlantReminder) {
        if let index = plantReminders.firstIndex(where: { $0.id == plant.id }) {
            plantReminders[index] = plant
            savePlants()
            
            // Cancel old notification and schedule new one
            NotificationManager.shared.cancelNotificationForPlant(plant)
            NotificationManager.shared.scheduleReminderForPlant(plant)
        }
    }
    
    // MARK: - Delete Plant with Notification
    func deletePlant(_ plant: PlantReminder) {
        plantReminders.removeAll { $0.id == plant.id }
        savePlants()
        
        // Cancel notification for deleted plant
        NotificationManager.shared.cancelNotificationForPlant(plant)
    }
    
    // MARK: - Toggle Check
    func toggleCheck(for plant: PlantReminder) {
        if let index = plantReminders.firstIndex(where: { $0.id == plant.id }) {
            plantReminders[index].isChecked.toggle()
            savePlants()
            
            // Reset app badge when user checks plants
            if plantReminders[index].isChecked {
                NotificationManager.shared.resetBadgeCount()
            }
        }
    }
    
    private func savePlants() {
        if let encoded = try? JSONEncoder().encode(plantReminders) {
            UserDefaults.standard.set(encoded, forKey: "SavedPlants")
        }
    }
    
    func loadPlants() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedPlants"),
           let decoded = try? JSONDecoder().decode([PlantReminder].self, from: savedData) {
            plantReminders = decoded
            
            // Reschedule notifications for all plants when app loads
            for plant in plantReminders {
                NotificationManager.shared.scheduleReminderForPlant(plant)
            }
        }
    }
    
    func resetAllChecks() {
        for index in plantReminders.indices {
            plantReminders[index].isChecked = false
        }
        savePlants()
    }
}
