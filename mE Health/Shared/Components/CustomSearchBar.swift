//
//  CustomSearchBar.swift
//  mE Health
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: Constants.API.PrimaryColorHex))
                .padding(.leading, 8)

            TextField("Search by Name, City or Country", text: $text)
                 .font(.montserrat(14, weight: .regular))
                .padding(.vertical, 10)
                .padding(.horizontal, 4)
                .doneToolbar()
        }
        .frame(height: 50) // 👈 Fixed height
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: Constants.API.PrimaryColorHex), lineWidth: 1.5)
        )
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
