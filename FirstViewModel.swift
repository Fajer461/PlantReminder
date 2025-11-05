//
//  FirstViewModel.swift
//  Planto1
//
//  Created by Fajer saleh on 14/05/1447 AH.
//

import Foundation
import SwiftUI
internal import Combine

// MARK: - First View Model
class FirstViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var showReminderSheet: Bool = false
    @Published var showMainView: Bool = false
    @Published var plantViewModel: PlantReminderViewModel
    
    // MARK: - Initializer
    init() {
        self.plantViewModel = PlantReminderViewModel()
    }
    
    // MARK: - Actions
    
    // Opens the reminder sheet with smooth slide up
    func openReminderSheet() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showReminderSheet = true
        }
    }
    
    // Closes the sheet without saving
    func closeReminderSheet() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showReminderSheet = false
        }
    }
    
    // Saves plant and transitions to MainView smoothly
    func savePlantAndNavigate(_ plant: PlantReminder) {
        // Add plant to ViewModel
        plantViewModel.addPlant(plant)
        
        // Smooth transition sequence:
        // 1. Start showing MainView behind the sheet
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.showMainView = true
            }
        }
        
        // 2. Slide the sheet down
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                self.showReminderSheet = false
            }
        }
    }
    
    // Reset navigation state
    func resetNavigation() {
        showMainView = false
        showReminderSheet = false
    }
}
