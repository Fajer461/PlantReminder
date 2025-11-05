//
//  ReminderView.swift
//  Planto1
//
//  Created by Fajer saleh on 14/05/1447 AH.
//

import SwiftUI


// MARK: - Plant Reminder Sheet View
// Can be used for both ADDING new plants and EDITING existing plants
struct PlantReminderSheet: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    var onSave: (PlantReminder) -> Void
    var onDelete: ((PlantReminder) -> Void)? // Optional: only used in edit mode
    
    // Optional: If provided, we're in EDIT mode. If nil, we're in ADD mode
    var existingPlant: PlantReminder?
    
    // MARK: - State Variables
    @State private var plantName: String = ""
    @State private var selectedRoom: String = "Bedroom"
    @State private var selectedLight: String = "Full sun"
    @State private var wateringFrequency: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"
    
    // Track if we're in edit mode
    private var isEditMode: Bool {
        existingPlant != nil
    }
    
    // MARK: - Data Arrays
    let rooms = ["Living Room", "Bedroom", "Kitchen", "Bathroom", "Balcony",]
    let lightOptions = ["Full sun", "Partial sun",  "Low light"]
    let wateringOptions = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 2 weeks"]
    let waterAmounts = ["10-20 ml", "20-50 ml", "50-100 ml", "100-200 ml", "200+ ml"]
    
    var body: some View {
        ZStack {
            // MARK: - Dimmed Background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // MARK: - Sheet Container
                VStack(spacing: 0) {
                    // MARK: - Header Bar
                    HStack {
                        // Close Button (X)
                        Button(action: {
                            withAnimation {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background(Color(white: 0.2))
                                .clipShape(Circle())
                                
                        }
                        
                        
                        Spacer()
                        
                        // Title - changes based on mode
                        Text(isEditMode ? "Edit Reminder" : "Set Reminder")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Save Button
                        Button(action: {
                            saveReminder()
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 44, height: 44)
                                .background(Color(hex: "22BA8C"))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 16)
                    .background(Color(white: 0.1))
                    
                  
                    // MARK: - Form Content
                
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Plant Name Text Field
                            HStack {
                                Text("Plant Name")
                                    .foregroundColor(.white)
                                Text("|")
                                    .foregroundColor(.gray)
                                TextField("Enter plant name", text: $plantName)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(white: 0.15))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .padding(.top, 40)
                            
                            // Room and Light selct
                            VStack(spacing: 0) {
                                // Room Picker
                                Menu {
                                    ForEach(rooms, id: \.self) { room in
                                        Button(action: {
                                            selectedRoom = room
                                        }) {
                                            HStack {
                                                Text(room)
                                                if selectedRoom == room {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "location")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Text("Room")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(selectedRoom)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .contentShape(Rectangle())
                                    .cornerRadius(20)
                                }
                                
                                
                                Divider()
                                    .background(Color(white: 0.25))
                                    .padding(.leading, 52)
                                
                                // Light Picker
                                Menu {
                                    ForEach(lightOptions, id: \.self) { light in
                                        Button(action: {
                                            selectedLight = light
                                        }) {
                                            HStack {
                                                Text(light)
                                                if selectedLight == light {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "sun.max")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Text("Light")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(selectedLight)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .contentShape(Rectangle())
                                    .cornerRadius(20)
                                }
                            }
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            //  Watering Select
                            VStack(spacing: 0) {
                                
                                Menu {
                                    ForEach(wateringOptions, id: \.self) { option in
                                        Button(action: {
                                            wateringFrequency = option
                                        }) {
                                            HStack {
                                                Text(option)
                                                if wateringFrequency == option {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "drop")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Text("Watering Days")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(wateringFrequency)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .contentShape(Rectangle())
                                    .cornerRadius(20)
                                }
                                
                                
                                Divider()
                                    .background(Color(white: 0.25))
                                    .padding(.leading, 52)
                                
                                // Water Amount
                                Menu {
                                    ForEach(waterAmounts, id: \.self) { amount in
                                        Button(action: {
                                            waterAmount = amount
                                        }) {
                                            HStack {
                                                Text(amount)
                                                if waterAmount == amount {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "drop")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Text("Water")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(waterAmount)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.up.chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                    .padding()
                                    .background(Color(white: 0.15))
                                    .contentShape(Rectangle())
                                    .cornerRadius(20)
                                }
                                
                            }
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            // MARK: - Delete Button in edit
                            if isEditMode {
                                Button(action: {
                                    deleteReminder()
                                }) {
                                    Text("Delete Reminder")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color(white: 0.15))
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            }
                            
                            Spacer(minLength: 40)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(white: 0.1))
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .ignoresSafeArea()
        // MARK: - Load Plant Data
        
        .onAppear {
            if let plant = existingPlant {
                // Load existing plant data into form fields
                plantName = plant.plantName
                selectedRoom = plant.room
                selectedLight = plant.lightCondition
                waterAmount = plant.waterAmount
            }
        }
    }
    
    // MARK: - Save
    func saveReminder() {
        guard !plantName.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Plant name is required")
            return
        }
        
        // Create updated plant (keeping same ID if editing)
        let updatedReminder = PlantReminder(
            id: existingPlant?.id ?? UUID(), // Keep same ID if editing
            plantName: plantName,
            room: selectedRoom,
            lightCondition: selectedLight,
            waterAmount: waterAmount,
            isChecked: existingPlant?.isChecked ?? false // Keep checked state
        )
        
        onSave(updatedReminder)
        
//        print("✅ Saved: \(plantName)")
        
        withAnimation {
            isPresented = false
        }
    }
    
    // MARK: - Delete plant
    func deleteReminder() {
        guard let plant = existingPlant else { return }
        onDelete?(plant)
        
//        print("🗑️ Deleted: \(plant.plantName)")
        
        withAnimation {
            isPresented = false
        }
    }
}

//to make corners more radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Custom Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.purple
        // Preview for ADD mode
        PlantReminderSheet(isPresented: .constant(true)) { _ in
            print("Preview save")
        }
        
        
    }
}
