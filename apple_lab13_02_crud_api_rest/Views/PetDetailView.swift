//
//  PetDetailView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/PetDetailView.swift
struct PetDetailView: View {
    let pet: Pet
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pet Header
                VStack(spacing: 10) {
                    Text(pet.typeEmoji)
                        .font(.system(size: 80))
                    
                    Text(pet.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(pet.typeName)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Pet Details
                VStack(spacing: 16) {
                    DetailRow(title: "Pet ID", value: "\(pet.id)")
                    DetailRow(title: "Type ID", value: "\(pet.typeId)")
                    DetailRow(title: "Owner ID", value: "\(pet.ownerId)")
                    DetailRow(title: "Birth Date", value: pet.birthDate)
                    DetailRow(title: "Age", value: "\(pet.age) years old")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Pet Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}
/*
#Preview {
    PetDetailView()
}*/
