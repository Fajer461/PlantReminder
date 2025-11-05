//
//  MainPage.swift
//  Planto1
//
//  Created by Fajer saleh on 14/05/1447 AH.
//

import SwiftUI




// MARK: - Main View
struct MainView: View {
    @ObservedObject var viewModel: PlantReminderViewModel
    @State private var showAddSheet = false
    @State private var selectedPlant: PlantReminder? = nil
    
    // Check if all plants are watered (checked)
    var allPlantsCompleted: Bool {
        !viewModel.plantReminders.isEmpty &&
        viewModel.plantReminders.allSatisfy { $0.isChecked }
    }
    
    // MARK: - Dynamic Progress Message
    var progressMessage: String {
        let total = viewModel.plantReminders.count
        let checked = viewModel.checkedCount
        
        if total == 0 {
            return "Add your first plant! 🌱"
        } else if checked == 0 {
            return "Your plants are waiting for a sip 💧"
        } else if checked == total {
            return "All plants feel loved today! ✨"
        } else if viewModel.progressPercentage >= 0.75 {
            return "\(checked) of your plants feel loved today ✨"
        } else if viewModel.progressPercentage >= 0.5 {
            return "\(checked) of your plants feel loved today ✨"
        } else {
            return "\(checked) of your plants feel loved today ✨"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Text("My Plants")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    Text("🌱")
                        .font(.system(size: 34))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // MARK: - Content Switcher
                if allPlantsCompleted {
                    // MARK: - All Done Screen
                    AllDoneView()
                        .transition(.scale.combined(with: .opacity))
                } else {
                    // MARK: - Normal Plant List View
                    VStack(spacing: 0) {
                        // MARK: - Dynamic Progress Banner
                        VStack(spacing: 12) {
                            Text(progressMessage)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .animation(.easeInOut, value: progressMessage)
                            
                            // Progress Bar
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 8)
                                
                                Rectangle()
                                    .fill(Color(hex: "22BA8C"))
                                    .frame(width: UIScreen.main.bounds.width * 0.9 * viewModel.progressPercentage, height: 8)
                                    .animation(.spring(), value: viewModel.progressPercentage)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        // Plant List
                        List {
                            ForEach(viewModel.plantReminders) { reminder in
                                PlantReminderRow(
                                    reminder: reminder,
                                    onToggle: {
                                        withAnimation(.spring()) {
                                            viewModel.toggleCheck(for: reminder)
                                        }
                                    },
                                    onTap: {
                                        selectedPlant = reminder
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            viewModel.deletePlant(reminder)
                                        }
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 20))
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            
            // MARK: - Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(hex: "22BA8C"))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: allPlantsCompleted)
        // MARK: - Add New Plant Sheet
        .sheet(isPresented: $showAddSheet) {
            PlantReminderSheet(isPresented: $showAddSheet) { newPlant in
                withAnimation {
                    viewModel.addPlant(newPlant)
                }
            }
        }
        // MARK: - Edit Sheet
        .sheet(item: $selectedPlant) { plant in
            PlantReminderSheet(
                isPresented: Binding(
                    get: { selectedPlant != nil },
                    set: { if !$0 { selectedPlant = nil } }
                ),
                onSave: { updatedPlant in
                    withAnimation {
                        viewModel.updatePlant(updatedPlant)
                    }
                    selectedPlant = nil
                },
                onDelete: { plantToDelete in
                    withAnimation {
                        viewModel.deletePlant(plantToDelete)
                    }
                    selectedPlant = nil
                },
                existingPlant: plant
            )
        }
        .onAppear {
            viewModel.loadPlants()
        }
    }
}

// MARK: - All Done View Component
struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("plant2")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
            
            Text("All Done! 🎉")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Text("All Reminders Completed")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Plant Reminder Row with Shadow Effect
struct PlantReminderRow: View {
    let reminder: PlantReminder
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Checkbox
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .strokeBorder(reminder.isChecked ? Color.green : Color.white.opacity(0.3), lineWidth: 2)
                        .background(
                            Circle()
                                .fill(reminder.isChecked ? Color(hex: "22BA8C") : Color.clear)
                        )
                        .frame(width: 24, height: 24)
                    
                    if reminder.isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .background(Color(hex: "22BA8C"))
                    }
                }
            }
            
            // MARK: - Plant Info with Conditional Shadow
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text("in \(reminder.room)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Text(reminder.plantName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "sun.max")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "CCC785"))
                        Text(reminder.lightCondition)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "CCC785"))
                        
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "CAF3FB"))
                        Text(reminder.waterAmount)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "CAF3FB"))
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
            // MARK: - Shadow Overlay for Checked Plants
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(reminder.isChecked ? 0.5 : 0))
                    .allowsHitTesting(false)
            )
            .animation(.easeInOut(duration: 0.3), value: reminder.isChecked)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.black))
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}











#Preview {
    MainView(viewModel: PlantReminderViewModel())
}
