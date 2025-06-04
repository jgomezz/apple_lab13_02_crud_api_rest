//
//  PetsListView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/PetsListView.swift
struct PetsListView: View {
    let pets: [Pet]
    let onEdit: (Pet) -> Void
    let onDelete: (Pet) -> Void
    
    var body: some View {
        List(pets) { pet in
            NavigationLink(destination: PetDetailView(pet: pet)) {
                PetRowView(pet: pet)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("Delete", role: .destructive) {
                    onDelete(pet)
                }
                
                Button("Edit") {
                    onEdit(pet)
                }
                .tint(.blue)
            }
        }
    }
}
/*
#Preview {
    PetsListView()
}*/
