//
//  PetsAPIService.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Services/PetsAPIService.swift
import Foundation

@MainActor
class PetViewModel: ObservableObject {
    
    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingAlert = false
    
    private let petService: PetServiceProtocol
    
    init(petService: PetServiceProtocol = PetService()) {
        self.petService = petService
    }
    
    // MARK: - GET All Pets
    func fetchPets() async {
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let fetchedPets = try await petService.fetchPets()
            self.pets = fetchedPets
        } catch {
            self.errorMessage = self.handleError(error)
            self.showingAlert = true
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Pet by ID
     func fetchPet(id: Int) async -> Pet? {
         do {
             return try await petService.fetchPet(id: id)
         } catch {
             self.errorMessage = handleError(error)
             self.showingAlert = true
             return nil
         }
     }
    
    // MARK: - Create Pet
    func createPet(_ pet: Pet) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let createdPet = try await petService.createPet(pet)
            self.pets.append(createdPet)
            return true
        } catch {
            self.errorMessage = handleError(error)
            self.showingAlert = true
            return false
        }
    }
    
    // MARK: - Update Pet
    func updatePet(_ pet: Pet) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let updatedPet = try await petService.updatePet(pet)
            if let index = self.pets.firstIndex(where: { $0.id == pet.id }) {
                self.pets[index] = updatedPet
            }
            return true
        } catch {
            self.errorMessage = handleError(error)
            self.showingAlert = true
            return false
        }
    }
    
    // MARK: - Delete Pet
    func deletePet(id: Int) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await petService.deletePet(id: id)
            self.pets.removeAll { $0.id == id }
            return true
        } catch {
            self.errorMessage = handleError(error)
            self.showingAlert = true
            return false
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) -> String {
        if let networkError = error as? NetworkError {
            return networkError.localizedDescription
        } else {
            return NetworkError.networkError(error).localizedDescription
        }
    }
}
