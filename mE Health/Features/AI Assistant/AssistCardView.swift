//
//  AssistCardView.swift
//  mE Health
//
//  Created by Rashida on 25/06/25.
//

import SwiftUI


struct AssistResponse : Codable {
    let mE_text_res : String?
    let data : [AssistData]?
    let status : Int?

    enum CodingKeys: String, CodingKey {
        case mE_text_res = "mE_text_res"
        case data = "data"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mE_text_res = try values.decodeIfPresent(String.self, forKey: .mE_text_res)
        data = try values.decodeIfPresent([AssistData].self, forKey: .data)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

struct AssistDummyData: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
}


struct AssistData: Identifiable, Equatable, Codable {
    let id : Int?
    let application : String?
    let category : String?
    let item : String?
    let default_activation_for_assist : Bool?
    let frequency : String?
    let frequency_in_days : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case application = "application"
        case category = "category"
        case item = "item"
        case default_activation_for_assist = "default_activation_for_assist"
        case frequency = "frequency"
        case frequency_in_days = "frequency_in_days"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        application = try values.decodeIfPresent(String.self, forKey: .application)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        item = try values.decodeIfPresent(String.self, forKey: .item)
        default_activation_for_assist = try values.decodeIfPresent(Bool.self, forKey: .default_activation_for_assist)
        frequency = try values.decodeIfPresent(String.self, forKey: .frequency)
        frequency_in_days = try values.decodeIfPresent(Int.self, forKey: .frequency_in_days)
    }

}


struct AssistCardView: View {
    
    let assist: AssistData
    let onTap: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .top, spacing: 12) {
                Text(assist.item ?? "")
                    .font(.montserrat(16, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
                Spacer()
                
                Image("right_arrow")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "FF6605"), lineWidth: 1.5) // Orange border
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
        .contentShape(Rectangle()) // Ensures whole card is tappable if needed
        .onTapGesture {
            onTap()
        }
    }
}

