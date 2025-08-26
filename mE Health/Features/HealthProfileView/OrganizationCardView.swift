//
//  OrganizationCardView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import SwiftUI

struct OrganisationResponse: Codable, Equatable  {
    let organizations: [Organization]
}


struct Organization: Codable, Identifiable , Equatable{
    let id: String
    let name: String
    let telecom: String
    let address: String

    var phone: String? {
        telecom
            .components(separatedBy: ";")
            .first(where: { $0.hasPrefix("phone:") })?
            .replacingOccurrences(of: "phone:", with: "")
    }

    var email: String? {
        telecom
            .components(separatedBy: ";")
            .first(where: { $0.hasPrefix("email:") })?
            .replacingOccurrences(of: "email:", with: "")
    }
}


struct OrganizationCardView: View {
    let organization: Organization

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(organization.name)
                    .font(.montserrat(14, weight: .bold))
                    .foregroundColor(.black)

                Text(organization.address)
                     .font(.montserrat(12, weight: .regular))
                    .foregroundColor(Color(hex: "FF6605"))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true) // ✅ Allow text to wrap

            }

            Spacer()

            Image("ME-Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8)) // ✅ Rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1) // ✅ Border
                )

        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 4)
        .frame(width: 310,height:90)
    }
}

struct AppoitmentCardView: View {
    let organization: Organization
    var showStatus : Bool
    let status : String
    
    var body: some View {
        HStack(spacing: 12) {
            Image("date_placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(hex: "FF6605"))
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack(spacing: 8) {
                    
                    Text("Jan 1, 2023") // You can pull from organization.type if dynamic
                        .font(.montserrat(16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if showStatus {
                        
                        if status ==  "booked" {
                            
                            Text("Booked")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "0063F7").opacity(0.2))
                                .foregroundColor(Color(hex: "0063F7"))
                                .clipShape(Capsule())

                        }
                        else if status ==  "cancel" {
                            Text("Canceled")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(Color.red)
                                .clipShape(Capsule())
                        }
                        else if status ==  "fulfilled" {
                            Text("fulfilled")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "06C270").opacity(0.2))
                                .foregroundColor(Color(hex: "06C270"))
                                .clipShape(Capsule())
                        }

                    }
                    
                }
                
                Text(organization.name)
                     .font(.montserrat(12, weight: .regular))
                    .foregroundColor(Color(hex: "FF6605"))
            }
            
            if !showStatus {
                Spacer() // Optional: pushes content to left, consistent spacing
            }
        }
        .padding(.horizontal, 12) // Internal horizontal padding
        .frame(height: 80)
        .background(Color.white)
    }
}


struct PractionerAppoitmentsCardView: View {
    let name : String
    let dateTime : String
    
    var body: some View {
        HStack(spacing: 12) {
            Image("date_placeholder")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(hex: "FF6605"))
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(name) // You can pull from organization.type if dynamic
                    .font(.montserrat(14, weight: .medium))
                    .foregroundColor(.black)

                
                Text(dateTime)
                     .font(.montserrat(10, weight: .regular))
                    .foregroundColor(Color(hex: "FF6605"))
            }
            
        }
        .padding(.horizontal, 12) // Internal horizontal padding
        .frame(height: 65)
        .background(Color.white)
    }
}
