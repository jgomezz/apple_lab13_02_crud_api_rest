//
//  EmptyStateView.swift
//  apple_lab13_02_crud_api_rest
//
//  Created by developer on 6/4/25.
//

import SwiftUI

// MARK: - Views/EmptyStateView.swift
struct EmptyStateView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "pawprint.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Pets Found")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Make sure your API server is running on localhost:8080")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Try Again") {
                onRefresh()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
/*
#Preview {
    EmptyStateView()
}*/
