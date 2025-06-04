//
//  Pet.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

// MARK: - Models/Pet.swift
import Foundation

struct Pet: Codable, Identifiable {
    let id: Int
    let name: String
    let typeId: Int
    let ownerId: Int
    let birthDate: String
    
    // Computed property for age calculation
    var age: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let birthDate = formatter.date(from: self.birthDate) else {
            return 0
        }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
    
    // Pet type name mapping
    var typeName: String {
        switch typeId {
        case 1: return "Cat"
        case 2: return "Dog"
        case 3: return "Lizard"
        case 4: return "Snake"
        case 5: return "Bird"
        case 6: return "Hamster"
        default: return "Unknown"
        }
    }
    
    // Pet type emoji
    var typeEmoji: String {
        switch typeId {
        case 1: return "🐱"
        case 2: return "🐶"
        case 3: return "🦎"
        case 4: return "🐍"
        case 5: return "🐦"
        case 6: return "🐹"
        default: return "🐾"
        }
    }
    
    // For creating new pets
    init(id: Int, name: String, typeId: Int, ownerId: Int, birthDate: String) {
        self.id = id
        self.name = name
        self.typeId = typeId
        self.ownerId = ownerId
        self.birthDate = birthDate
    }
}
