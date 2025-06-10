//
//  ContentView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Views/ContentView.swift
import SwiftUI

struct ContentView: View {
    
    @StateObject private var petViewModel = PetViewModel()
    
    @State private var showingAddPet = false
    @State private var selectedPet: Pet?
    @State private var showingEditPet = false
    @State private var showingDeleteAlert = false
    @State private var petToDelete: Pet?
    
    var body: some View {
        NavigationView {
            Group {
                if petViewModel.isLoading && petViewModel.pets.isEmpty {
                    ProgressView("Loading pets...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if petViewModel.pets.isEmpty && !petViewModel.isLoading {
                    EmptyStateView {
                        Task {
                            await petViewModel.fetchPets()
                        }
                    }
                } else {
                    PetsListView(
                        pets: petViewModel.pets,
                        onEdit: { pet in
                            selectedPet = pet
                            showingEditPet = true
                        },
                        onDelete: { pet in
                            petToDelete = pet
                            showingDeleteAlert = true
                        }
                    )
                    .refreshable {
                        await petViewModel.fetchPets()
                    }
                }
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        Task {
                            await petViewModel.fetchPets()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetView(petViewModel: petViewModel)
            }
            .sheet(isPresented: $showingEditPet) {
                if let pet = selectedPet {
                    EditPetView(petViewModel:petViewModel, pet: pet)
                }
            }
            .alert("Delete Pet", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let pet = petToDelete {
                        Task {
                            await deletePet(pet)
                        }
                    }
                }
            } message: {
                if let pet = petToDelete {
                    Text("Are you sure you want to delete \(pet.name)?")
                }
            }
            .alert("Error", isPresented: .constant(petViewModel.errorMessage != nil)) {
                Button("OK") {
                    petViewModel.errorMessage = nil
                }
            } message: {
                Text(petViewModel.errorMessage ?? "")
            }
            .task {
                if petViewModel.pets.isEmpty {
                    await petViewModel.fetchPets()
                }
            }
        }
    }
    
    private func deletePet(_ pet: Pet) async {

        _ = await petViewModel.deletePet(id: pet.id)

    }
}


#Preview {
    ContentView()
}
