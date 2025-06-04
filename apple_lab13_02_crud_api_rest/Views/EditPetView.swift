//
//  EditPetView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/EditPetView.swift
struct EditPetView: View {
    @StateObject private var apiService = PetsAPIService.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var selectedTypeId: Int
    @State private var ownerId: Int
    @State private var birthDate: Date
    @State private var isUpdating = false
    @State private var errorMessage: String?
    
    private let pet: Pet
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(pet: Pet) {
        self.pet = pet
        self._name = State(initialValue: pet.name)
        self._selectedTypeId = State(initialValue: pet.typeId)
        self._ownerId = State(initialValue: pet.ownerId)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: pet.birthDate) ?? Date()
        self._birthDate = State(initialValue: date)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pet Information")) {
                    TextField("Pet Name", text: $name)
                    
                    Picker("Pet Type", selection: $selectedTypeId) {
                        ForEach(PetType.allTypes) { type in
                            HStack {
                                Text(type.emoji)
                                Text(type.name)
                            }
                            .tag(type.id)
                        }
                    }
                    
                    Stepper("Owner ID: \(ownerId)", value: $ownerId, in: 1...100)
                    
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: updatePet) {
                        HStack {
                            if isUpdating {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text("Update Pet")
                        }
                    }
                    .disabled(name.isEmpty || isUpdating)
                }
            }
            .navigationTitle("Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private func updatePet() {
        isUpdating = true

        let updatedPet = Pet(
            id: pet.id,
            name: name,
            typeId: selectedTypeId,
            ownerId: ownerId,
            birthDate: dateFormatter.string(from: birthDate)
        )

        
        Task {
            do {
                _ = try await apiService.updatePet(updatedPet)
                await MainActor.run {
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isUpdating = false
                }
            }
        }
    }
}

/*
#Preview {
    EditPetView()
}*/
