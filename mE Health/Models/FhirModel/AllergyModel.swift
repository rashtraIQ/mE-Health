//
//  AllergyModel.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 12/06/25.
//


import Foundation
struct AllergyResponse: Codable {
    let allergyIntolerances: [AllergyData]
}


struct AllergyData: Identifiable, Equatable, Codable {
    let id: String
    let codeSystem: String
    let codeDisplay: String
    let rawCode: String
    let clinicalStatus: String
    let patientId: String
    let encounterId: String
    let recordedDate: String
    let createdAt: String
    let updatedAt: String

    // Parsed code object
    var code: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawCode.utf8))
    }
    
    var formattedRecordedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: recordedDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return recordedDate
    }


    enum CodingKeys: String, CodingKey {
        case id
        case codeSystem = "code_system"
        case codeDisplay = "code_display"
        case rawCode = "code"
        case clinicalStatus
        case patientId
        case encounterId
        case recordedDate
        case createdAt
        case updatedAt
    }
}
