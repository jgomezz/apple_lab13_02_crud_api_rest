//
//  ContentView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Views/ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject private var apiService = PetsAPIService.shared
    @State private var showingAddPet = false
    @State private var selectedPet: Pet?
    @State private var showingEditPet = false
    @State private var showingDeleteAlert = false
    @State private var petToDelete: Pet?
    
    var body: some View {
        NavigationView {
            Group {
                if apiService.isLoading && apiService.pets.isEmpty {
                    ProgressView("Loading pets...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if apiService.pets.isEmpty && !apiService.isLoading {
                    EmptyStateView {
                        Task {
                            await apiService.fetchPets()
                        }
                    }
                } else {
                    PetsListView(
                        pets: apiService.pets,
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
                        await apiService.fetchPets()
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
                            await apiService.fetchPets()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetView()
            }
            .sheet(isPresented: $showingEditPet) {
                if let pet = selectedPet {
                    EditPetView(pet: pet)
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
            .alert("Error", isPresented: .constant(apiService.errorMessage != nil)) {
                Button("OK") {
                    apiService.errorMessage = nil
                }
            } message: {
                Text(apiService.errorMessage ?? "")
            }
            .task {
                if apiService.pets.isEmpty {
                    await apiService.fetchPets()
                }
            }
        }
    }
    
    private func deletePet(_ pet: Pet) async {
        do {
            try await apiService.deletePet(id: pet.id)
        } catch {
            apiService.errorMessage = error.localizedDescription
        }
    }
}


#Preview {
    ContentView()
}
