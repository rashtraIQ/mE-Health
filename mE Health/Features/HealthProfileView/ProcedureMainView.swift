//
//  ProcedureMainView.swift
//  mE Health
//
//  Created by Rashida on 24/06/25.
//

import SwiftUI

struct ProcedureJsonResponse: Codable {
    let procedures: [ProcedureDummyData]
}

struct CodeInfo: Codable , Equatable{
    let system: String
    let code: String
    let display: String
}


struct ProcedureDummyData: Codable,Identifiable, Equatable {
    let id: String
    let codeSystem: String
    let rawCode: String
    let codeDisplay: String
    let performedDate: String
    let rawReasonCode: String
    let patientId: String
    let encounterId: String
    let createdAt: String
    let updatedAt: String
    let status: String
    
    var code: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawCode.utf8))
    }

    var reasonCode: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawReasonCode.utf8))
    }
    
    var performedFormattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: performedDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return performedDate
    }

    enum CodingKeys: String, CodingKey {
        case id
        case codeSystem = "code_system"
        case rawCode = "code"
        case codeDisplay = "code_display"
        case status
        case performedDate
        case rawReasonCode = "reasonCode"
        case patientId
        case encounterId
        case createdAt
        case updatedAt
    }
    
    


}

enum ProcedureStatus: String, Codable {
    case completed = "Completed"
}



struct ProcedureMainView: View {

    let procedure: ProcedureDummyData
    let onTap: () -> Void
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(procedure.codeDisplay ?? "Unknown Code")
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        
                        if procedure.status ==  "completed" {
                                Text("Completed")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "06C270").opacity(0.2))
                                .foregroundColor(Color(hex: "06C270"))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text(procedure.performedFormattedDate)
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

struct ProcedureSectionView: View {
    let procedure: [ProcedureDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (ProcedureDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    var filteredAppointments: [ProcedureDummyData] {
        procedure.filter { fileData in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = fileData.codeDisplay.localizedCaseInsensitiveContains(searchText)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: fileData.createdAt) {
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
                $0.label.lowercased() == fileData.status.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus


        }
    }

    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            
            if filteredAppointments.isEmpty {
                NoDataView()
            } else {
                ForEach(filteredAppointments) { procData in
                    ProcedureMainView(procedure: procData) {
                        onCardTap(procData)
                    }
                }
            }

        }
        .padding(.horizontal)

    }
}
