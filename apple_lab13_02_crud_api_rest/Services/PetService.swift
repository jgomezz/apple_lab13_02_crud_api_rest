//
//  PetService.swift
//  apple_lab13_01_api_rest
//
//  Created by Jaime Gomez on 8/6/25.
//

// MARK: - Services/PetService.swift
import Foundation

protocol PetServiceProtocol {
    func fetchPets() async throws -> [Pet]
    func fetchPet(id: Int) async throws -> Pet
    func createPet(_ pet: Pet) async throws -> Pet
    func updatePet(_ pet: Pet) async throws -> Pet
    func deletePet(id: Int) async throws
}

class PetService: PetServiceProtocol {
    private let session = URLSession.shared
    private let baseURL = "http://ec2-54-173-250-127.compute-1.amazonaws.com:8080"
    
    // MARK: - GET All Pets
    func fetchPets() async throws -> [Pet] {
        guard let url = URL(string: "\(baseURL)/pets") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode([Pet].self, from: data)
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
        
        return try JSONDecoder().decode(Pet.self, from: data)
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
        
        return try JSONDecoder().decode(Pet.self, from: data)
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
    }
}
