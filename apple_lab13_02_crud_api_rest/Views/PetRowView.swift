//
//  PetRowView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/PetRowView.swift
struct PetRowView: View {
    let pet: Pet
    
    var body: some View {
        HStack {
            Text(pet.typeEmoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)
                
                HStack {
                    Text(pet.typeName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text("\(pet.age) years old")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Owner ID: \(pet.ownerId)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(pet.birthDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

/*
#Preview {
    PetRowView()
}*/
