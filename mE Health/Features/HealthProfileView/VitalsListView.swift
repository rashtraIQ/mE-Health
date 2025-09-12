//
//  VitalsListView.swift
//  mE Health
//
//  Created by Rashida on 27/06/25.
//
import SwiftUI


struct ObservationResponse: Codable, Equatable {
    let observations: [VitalDummyData]
}

struct VitalDummyData: Codable, Identifiable, Equatable {
    let id: String
    let codeSystem: String
    let code: String
    let codeDisplay: String
    let codeDetailRaw: String
    let categoryRaw: String
    let valueRaw: String
    let description: String
    let status: String
    let effectiveDate: String
    let valueQuantityValue: Double?
    let valueQuantityUnit: String?
    let valueString: String?
    let referenceRangeLow: Double?
    let referenceRangeHigh: Double?
    let patientId: String
    let encounterId: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case codeSystem = "code_system"
        case code
        case codeDisplay = "code_display"
        case codeDetailRaw = "code_detail"
        case categoryRaw = "category"
        case valueRaw = "value"
        case description
        case status
        case effectiveDate
        case valueQuantityValue = "valueQuantity_value"
        case valueQuantityUnit = "valueQuantity_unit"
        case valueString
        case referenceRangeLow = "referenceRange_low"
        case referenceRangeHigh = "referenceRange_high"
        case patientId
        case encounterId
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

    var codeDetail: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(codeDetailRaw.utf8))
    }

    var category: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(categoryRaw.utf8))
    }

    var value: ValueInfo? {
        try? JSONDecoder().decode(ValueInfo.self, from: Data(valueRaw.utf8))
    }
}

struct ValueInfo: Codable, Equatable {
    let value: String
    let unit: String
}

struct VitalsListView: View {

    let vital: VitalDummyData
    let onTap: () -> Void
        
        
        var body: some View {
            Button(action: onTap){
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(vital.codeDisplay)
                            .font(.montserrat(16, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(vital.formattedDate)
                            .font(.montserrat(12, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text("\(vital.valueQuantityValue ?? 0)" + " " + (vital.valueQuantityUnit ?? ""))
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
            .buttonStyle(PlainButtonStyle())

            
        }

}

struct  VitalsSectionView: View {
    let vitalsArray: [VitalDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (VitalDummyData) -> Void

    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }
    
    var filteredVitals: [VitalDummyData] {
        vitalsArray.filter { vital in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = vital.codeDisplay.localizedCaseInsensitiveContains(searchText)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: vital.createdAt) {
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
                $0.label.lowercased() == vital.status.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus

        }
    }

    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            if filteredVitals.isEmpty {
                NoDataView()
            } else {
                ForEach(filteredVitals) { vital in
                    VitalsListView(vital: vital) {
                        onCardTap(vital)
                    }
                }
            }

        }
        .padding(.horizontal)

    }
}
