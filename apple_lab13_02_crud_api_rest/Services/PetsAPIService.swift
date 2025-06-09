//
//  PetsAPIService.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Services/PetsAPIService.swift
import Foundation

@MainActor
class PetsAPIService: ObservableObject {
    static let shared = PetsAPIService()
    private let session = URLSession.shared
    private let baseURL = "http://3.92.45.93:8080"
    
    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - GET All Pets
    func fetchPets() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/pets") else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            isLoading = false
            return
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.connectionFailed
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decodedPets = try JSONDecoder().decode([Pet].self, from: data)
            self.pets = decodedPets
            
        } catch {
            if let networkError = error as? NetworkError {
                self.errorMessage = networkError.localizedDescription
            } else {
                self.errorMessage = NetworkError.networkError(error).localizedDescription
            }
        }
        
        isLoading = false
    }
    
    // MARK: - GET Pet by ID
    func fetchPet(id: Int) async throws -> Pet {
        guard let url = URL(string: "\(baseURL)/pets/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(0)
        }
        
        return try JSONDecoder().decode(Pet.self, from: data)
    }
    
    // MARK: - POST Create Pet
    func createPet(_ pet: Pet) async throws -> Pet {
        guard let url = URL(string: "\(baseURL)/pets") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(pet)
        } catch {
            throw NetworkError.encodingError(error)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(0)
        }
        
        let createdPet = try JSONDecoder().decode(Pet.self, from: data)
        
        // Update local pets array
        await MainActor.run {
            self.pets.append(createdPet)
        }
        
        return createdPet
    }
    
    // MARK: - PUT Update Pet
    func updatePet(_ pet: Pet) async throws -> Pet {
        guard let url = URL(string: "\(baseURL)/pets/\(pet.id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(pet)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(0)
        }
        
        let updatedPet = try JSONDecoder().decode(Pet.self, from: data)
        
        // Update local pets array
        await MainActor.run {
            if let index = self.pets.firstIndex(where: { $0.id == pet.id }) {
                self.pets[index] = updatedPet
            }
        }
        
        return updatedPet
    }
    
    // MARK: - DELETE Pet
    func deletePet(id: Int) async throws {
        guard let url = URL(string: "\(baseURL)/pets/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(0)
        }
        
        // Remove from local pets array
        await MainActor.run {
            self.pets.removeAll { $0.id == id }
        }
    }
}
