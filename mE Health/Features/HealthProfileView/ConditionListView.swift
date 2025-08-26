//
//  ConditionListView.swift
//  mE Health
//
//  Created by Rashida on 27/06/25.
//

import SwiftUI


struct ConditionResponse: Codable , Equatable{
    let conditions: [ConditionDummyData]
}

struct ConditionDummyData: Codable,Identifiable, Equatable {
    let id: String
    let codeSystem: String
    let codeValue: String
    let codeDisplay: String
    let codeRaw: String
    let categoryRaw: String
    let description: String
    let clinicalStatus: String
    let onsetDate: String
    let recordedDate: String
    let patientId: String
    let encounterId: String
    let createdAt: String
    let updatedAt: String
    
    var formattedOnSetDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: onsetDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return onsetDate
    }

    
    var formattedOnRecordDate: String {
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
        case codeValue = "code"
        case codeDisplay = "code_display"
        case codeRaw = "code_detail"
        case categoryRaw = "category"
        case description
        case clinicalStatus
        case onsetDate
        case recordedDate
        case patientId
        case encounterId
        case createdAt
        case updatedAt
    }

    // Computed properties to decode embedded JSON strings
    var code: CodeInfo? {
        decodeJSONString(from: codeRaw)
    }

    var category: CodeInfo? {
        decodeJSONString(from: categoryRaw)
    }

    private func decodeJSONString<T: Decodable>(from jsonString: String) -> T? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

enum ConditionStatus: String {
    case active = "Active"
    case resolved = "Resolved"
}



struct ConditionListView: View {

    let condition: ConditionDummyData
    let onTap: () -> Void
        
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(condition.codeDisplay)
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                            
                        if condition.clinicalStatus ==  "active" {
                            Text("Active")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "06C270").opacity(0.2))
                                .foregroundColor(Color(hex: "06C270"))
                                .clipShape(Capsule())

                        }
                        else  {
                            Text("Resolved")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "A811C7").opacity(0.2))
                                .foregroundColor(Color(hex: "A811C7"))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text(condition.formattedOnSetDate)
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

struct ConditionSectionView: View {
    let conditions: [ConditionDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (ConditionDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    
    var filteredAppointments: [ConditionDummyData] {
        conditions.filter { condition in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch =  condition.codeDisplay.localizedCaseInsensitiveContains(searchText)
            }
            let matchesDate: Bool
            if let start = startDate, let end = endDate {
                if let createdDate = dateFormatter.date(from: condition.createdAt) {
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
                $0.label.lowercased() == condition.clinicalStatus.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus
        }
    }

    
    var body: some View {
        
        VStack(spacing: 20) {
            if filteredAppointments.isEmpty {
                        NoDataView()
            } else {
                ForEach(filteredAppointments) { condition in
                    ConditionListView(condition: condition) {
                        onCardTap(condition)
                    }
                }
            }
        }
        .padding(.horizontal)

    }
}
