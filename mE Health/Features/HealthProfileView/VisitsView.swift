//
//  VisitsView.swift
//  mE Health
//


import SwiftUI

struct EncounterResponse: Codable, Equatable {
    let encounters: [VisitDummyData]
}


struct VisitDummyData: Identifiable, Equatable,Codable {
    let id: String
    let status: String
    let typeSystem: String
    let typeCode: String
    let typeDisplay: String
    let patientId: String
    let periodStart: String
    let periodEnd: String
    let practitionerId: String
    let organizationId: String
    let description: String
    let rawType: String
    let createdAt: String
    let updatedAt: String

    // Custom mapping for keys
    enum CodingKeys: String, CodingKey {
        case id, status, patientId, periodStart, periodEnd, practitionerId, organizationId, description, createdAt, updatedAt
        case typeSystem = "type_system"
        case typeCode = "type_code"
        case typeDisplay = "type_display"
        case rawType = "type"
    }
    
    var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: periodStart) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return periodStart
    }

    // Decode the embedded JSON string into a struct
    var type: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawType.utf8))
    }
}



struct VisitsView: View {

    let visit: VisitDummyData
    let onTap: () -> Void
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(visit.description)
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        
                        if visit.status ==  "planned" {
                            
                            Text("Planned")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "F09C00").opacity(0.2))
                                .foregroundColor(Color(hex: "F09C00"))
                                .clipShape(Capsule())

                        }
                        else if visit.status ==  "finished" {
                            Text("Finished")
                                .font(.montserrat(9, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(Color.green)
                                .clipShape(Capsule())
                        }
                        
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text(visit.formattedDate)
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

struct VisitsSectionView: View {
    let visit: [VisitDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (VisitDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    var filterVisits: [VisitDummyData] {
        visit.filter { vData in
            // 1. Filter by search
            let matchesSearch: Bool = searchText.isEmpty || vData.description.localizedCaseInsensitiveContains(searchText)
            
            // 2. Filter by date
            let matchesDate: Bool = {
                guard let start = startDate, let end = endDate else { return true }
                if let createdDate = dateFormatter.date(from: vData.createdAt) {
                    return (createdDate >= start) && (createdDate <= end)
                }
                return false
            }()
            
            // 3. Filter by status (skip "All")
            let activeFilters = selectedFilters.filter { $0.label != "All" }
            let matchesStatus: Bool = activeFilters.isEmpty || activeFilters.contains {
                $0.label.lowercased() == vData.status.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus
        }
    }

    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            
            if filterVisits.isEmpty {
                NoDataView()
            } else {
                ForEach(filterVisits) { visitData in
//                    VisitsView(visit: visitData) {
//                        onCardTap(visitData)
//                    }
                    NavigationLink(destination: VisitsDetailView(visit: visitData)) {
                                            VisitsView(visit: visitData) {
                                                onCardTap(visitData) // still call callback if needed
                                            }
                                            .contentShape(Rectangle()) // makes entire cell tappable
                                        }
                                        .buttonStyle(PlainButtonStyle())
                }
            }

        }
        .padding(.horizontal)
    }
}
