//
//  LabMainView.swift
//  mE Health
//
//  Created by Rashida on 18/06/25.
//


import SwiftUI


struct DiagnosticReportResponse: Codable {
    let diagnosticReports: [LabDummyData]
}



struct LabDummyData: Codable,Identifiable, Equatable {
    let id: String
    let codeSystem: String
    let codeValue: String
    let codeDisplay: String
    let codeRaw: String
    let status: String
    let effectiveDate: String
    let issued: String
    let patientId: String
    let encounterId: String
    let performerId: String
    let organizationId: String
    let result: [ResultReference]
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case codeSystem = "code_system"
        case codeValue = "code"
        case codeDisplay = "code_display"
        case codeRaw = "code_detail"
        case status
        case effectiveDate
        case issued
        case patientId
        case encounterId
        case performerId
        case organizationId
        case result
        case createdAt
        case updatedAt
    }

    var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: effectiveDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return effectiveDate
    }
    
    var fullFormattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: effectiveDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy 'at' hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            return formatter.string(from: date)
        }
        return effectiveDate
    }
    
    // Computed property to decode embedded code JSON string
    var code: CodeInfo? {
        guard let data = codeRaw.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(CodeInfo.self, from: data)
    }

}

struct ResultReference: Codable , Equatable{
    let reference: String
    let display: String
}


struct LabMainView: View {

    let lab: LabDummyData
    let onTap: () -> Void
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(lab.codeDisplay)
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        
                        if lab.status == "final" {
                            Text("Active")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .clipShape(Capsule())

                        }
                        else if lab.status == "preliminary"{
                            Text("Preliminary")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "F09C00").opacity(0.2))
                                .foregroundColor(Color(hex: "F09C00"))
                                .clipShape(Capsule())
                        }
                        
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text("Recorded Date: \(lab.formattedDate)")
                         .font(.montserrat(16, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal,12)

                    
                    Button(action: onTap) {
                        Text("View Details")
                           .font(.montserrat(14, weight: .bold))
                            .foregroundColor(.white)
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

struct LabSectionView: View {
    let labs: [LabDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (LabDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    var filteredAppointments: [LabDummyData] {
        labs.filter { lab in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch =   lab.codeDisplay.localizedCaseInsensitiveContains(searchText)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: lab.createdAt) {
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
                $0.label.lowercased() == lab.status.lowercased()
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
                ForEach(filteredAppointments) { labdata in
                    LabMainView(lab: labdata) {
                        onCardTap(labdata)
                    }
                }
            }
        }
        .padding(.horizontal)

    }
}
