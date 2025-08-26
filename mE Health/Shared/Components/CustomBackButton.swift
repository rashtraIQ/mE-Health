//
//  CustomBackButton.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 9/06/25.
//

import SwiftUI

struct CustomBackButton: View {
    var title: String = "Back"
    var color: Color = Color(hex: Constants.API.PrimaryColorHex)
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .medium))
                Text(title)
                    .font(.montserrat(16, weight: .medium))
            }
            .foregroundColor(color)
        }
    }
}



struct CustomButtonBackValue: View {
    var title: String
    var imageName: String
    var color: Color = Color(hex: Constants.API.PrimaryColorHex)
    var action: () -> Void
    
    let valueToPass: String
    let onBack: (String) -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.system(size: 17, weight: .medium))
                Text(title)
                    .font(.montserrat(16, weight: .medium))
            }
            .foregroundColor(color)
        }
    }
}
