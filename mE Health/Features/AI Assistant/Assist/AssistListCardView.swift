//
//  AssistListCardView.swift
//  mE Health
//
//  Created by Rashida on 26/06/25.
//
import SwiftUI

struct AssistListData: Identifiable, Equatable {
    let id = UUID()
    let dateRange: String
    let category: String
    let time: String
    let name: String
}





struct AssistListCardView: View {
    let assistData: AssistListData
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 12) {
                
                HStack(spacing: 0) {
                    Text("Category: ")
                       .font(.montserrat(14, weight: .bold))
                    Text(assistData.name)
                         .font(.montserrat(14, weight: .regular))
                       
                }

                Text(assistData.dateRange)
                     .font(.montserrat(13, weight: .regular))

                                
            }

//            Spacer()
            
//            AssistColumn()
//                .frame(height:100)
//                .padding(.trailing, 0)
        }
        .padding(.horizontal, 16) // Fine-tuned spacing
        .padding(.vertical, 8)
        .frame(height:100)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onTap()
        }
    }
}





struct AssistColumn: View {
    let icons = ["AI Advice", "delete"]

    var body: some View {
        VStack(spacing: 1) {
            ForEach(icons, id: \.self) { icon in
                Button(action: {
                    // Handle tap
                }) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .padding()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "FF6605"))
                }
            }
        }
        .padding(.trailing,0)
        .frame(width: 50) // Fixed width for the action column
        .background(
            RoundedCorners(color: Color.white, tl: 0, tr: 12, bl: 12, br: 0)
        )
    }
}


struct PatientResponse: Codable {
    let patients: [PatientDummyData]
}

struct PatientDummyData: Codable, Identifiable {
    let id: String
    let name: String
    let birthDate: String
    let gender: String
    let maritalStatus: String
    let createdAt: String
    let updatedAt: String
    let address: AddressDummy?
    let telecom: [TelecomDummy]?

    enum CodingKeys: String, CodingKey {
        case id, name, birthDate, gender, maritalStatus, createdAt, updatedAt
        case address, telecom
    }

    // Custom decoding to handle JSON strings inside fields
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        birthDate = try container.decode(String.self, forKey: .birthDate)
        gender = try container.decode(String.self, forKey: .gender)
        maritalStatus = try container.decode(String.self, forKey: .maritalStatus)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)

        let addressString = try container.decode(String.self, forKey: .address)
        address = try? JSONDecoder().decode(AddressDummy.self, from: Data(addressString.utf8))

        let telecomString = try container.decode(String.self, forKey: .telecom)
        telecom = try? telecomString
            .components(separatedBy: ";")
            .compactMap {
                try JSONDecoder().decode(TelecomDummy.self, from: Data($0.utf8))
            }
    }
}

struct AddressDummy: Codable {
    let line: [String]
    let city: String
    let state: String
    let postalCode: String
}

struct TelecomDummy: Codable {
    let system: String
    let value: String
}

