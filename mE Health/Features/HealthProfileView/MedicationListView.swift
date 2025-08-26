//
//  MedicationListView.swift
//  mE Health
//
//  Created by Rashida on 27/06/25.
//

import SwiftUI

struct MedicationRequestResponse: Codable {
    let medicationRequests: [MedicationDummyData]
}

struct MedicationDummyData: Identifiable, Codable, Equatable {
    let id: String
    let medicationCodeSystem: String
    let medicationCodeCode: String
    let medicationCodeDisplay: String
    let rawMedicationCode: String
    let description: String
    let status: String
    let authoredOn: String
    let rawDosageInstruction: String
    let rawReasonCode: String
    let patientId: String
    let encounterId: String
    let createdAt: String
    let updatedAt: String

    var medicationCode: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawMedicationCode.utf8))
    }

    var dosageInstruction: DosageInstruction? {
        try? JSONDecoder().decode(DosageInstruction.self, from: Data(rawDosageInstruction.utf8))
    }

    var reasonCode: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawReasonCode.utf8))
    }

    var formattedAuthoredDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: authoredOn) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return authoredOn
    }

    enum CodingKeys: String, CodingKey {
        case id
        case medicationCodeSystem = "medicationCode_system"
        case medicationCodeCode = "medicationCode_code"
        case medicationCodeDisplay = "medicationCode_display"
        case rawMedicationCode = "medicationCode"
        case description
        case status
        case authoredOn
        case rawDosageInstruction = "dosageInstruction"
        case rawReasonCode = "reasonCode"
        case patientId
        case encounterId
        case createdAt
        case updatedAt
    }
}

struct MedicationListView: View {

    let medication: MedicationDummyData
    let onTap: () -> Void
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(medication.description)
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        
                        Text(medication.status)
                            .font(.montserrat(9, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "06C270").opacity(0.2))
                            .foregroundColor(Color(hex: "06C270"))
                            .clipShape(Capsule())

                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text(medication.formattedAuthoredDate)
                         .font(.montserrat(14, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal,12)

                    
                    Button(action: onTap) {
                        Text("View Details")
                            .font(.montserrat(14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width:135)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "FF6605"))
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 12)
                    .padding(.horizontal,12)

                }
                .padding(.leading, 12)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)

    }
}

struct MedicationSectionView: View {
    let medications: [MedicationDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (MedicationDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

        
    var filteredMedication: [MedicationDummyData] {
        medications.filter { data in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch =   data.description.localizedCaseInsensitiveContains(searchText)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: data.createdAt) {
                    matchesDate = (createdDate >= start) && (createdDate <= end)
                } else {
                    matchesDate = false
                }
            } else {
                matchesDate = true // no date filter applied
            }
            
            // 3. Filter by status (skip "All")
            let activeFilters = selectedFilters.filter { $0.label != "All" }
            let matchesStatus: Bool = activeFilters.isEmpty || activeFilters.contains {
                $0.label.lowercased() == data.status.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus

        }
    }

    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            if filteredMedication.isEmpty {
                NoDataView()
            } else {
                ForEach(filteredMedication) { medicationData in
                    MedicationListView(medication: medicationData) {
                        onCardTap(medicationData)
                    }
                }
            }

        }
        .padding(.horizontal)

    }
}
