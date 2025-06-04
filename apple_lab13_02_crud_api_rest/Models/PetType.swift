//
//  PetType.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Models/PetType.swift
struct PetType: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    
    static let allTypes = [
        PetType(id: 1, name: "Cat", emoji: "🐱"),
        PetType(id: 2, name: "Dog", emoji: "🐶"),
        PetType(id: 3, name: "Lizard", emoji: "🦎"),
        PetType(id: 4, name: "Snake", emoji: "🐍"),
        PetType(id: 5, name: "Bird", emoji: "🐦"),
        PetType(id: 6, name: "Hamster", emoji: "🐹")
    ]
}
