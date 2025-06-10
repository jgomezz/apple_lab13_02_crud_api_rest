//
//  AddPetView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/AddPetView.swift
struct AddPetView: View {
    
    //@StateObject private var apiService = PetViewModel.shared
    @ObservedObject var petViewModel: PetViewModel

    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var selectedTypeId = 1
    @State private var ownerId = 1
    @State private var birthDate = Date()
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
                    Button(action: createPet) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text("Add Pet")
                        }
                    }
                    .disabled(name.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Add New Pet")
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
    
    private func createPet() {
        isSubmitting = true
        let newPet = Pet(
            id : 0,
            name: name,
            typeId: selectedTypeId,
            ownerId: ownerId,
            birthDate: dateFormatter.string(from: birthDate)
        )
        
        Task {
            _ = await petViewModel.createPet(newPet)
            await MainActor.run {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

/*
#Preview {
    AddPetView()
}*/
