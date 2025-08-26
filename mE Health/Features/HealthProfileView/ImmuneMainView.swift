
import SwiftUI

struct ImmuneResponse: Codable {
    let immunizations: [ImmuneDummyData]
}



struct ImmuneDummyData: Identifiable, Equatable, Codable {
    let id: String
    let vaccineCodeSystem: String
    let vaccineCodeCode: String
    let vaccineCodeDisplay: String
    let rawVaccineCode: String
    let status: String
    let occurrenceDate: String
    let patientId: String
    let encounterId: String
    let createdAt: String
    let updatedAt: String

    // Parsed vaccineCode as object
    var vaccineCode: CodeInfo? {
        try? JSONDecoder().decode(CodeInfo.self, from: Data(rawVaccineCode.utf8))
    }

    var formattedOccurrenceDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: occurrenceDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return occurrenceDate
    }

    enum CodingKeys: String, CodingKey {
        case id
        case vaccineCodeSystem = "vaccineCode_system"
        case vaccineCodeCode = "vaccineCode_code"
        case vaccineCodeDisplay = "vaccineCode_display"
        case rawVaccineCode = "vaccineCode"
        case status
        case occurrenceDate
        case patientId
        case encounterId
        case createdAt
        case updatedAt
    }
}

struct ImmuneMainView: View {

    let immune: ImmuneDummyData
    let onTap: () -> Void
        
        
        var body: some View {

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(immune.vaccineCodeDisplay)
                            .font(.montserrat(16, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                        
                        if immune.status == "completed" {
                            
                            Text("Completed")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .clipShape(Capsule())

                        }
                        else {
                            Text("Not Done")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "F02C2C").opacity(0.2))
                                .foregroundColor(Color(hex: "F02C2C"))
                                .clipShape(Capsule())
                        }
                        
                    }
                    .padding(.top,12)
                    .padding(.horizontal,12)

                    Text("Occurrence Date: \(immune.formattedOccurrenceDate)")
                        .font(.montserrat(14, weight: .medium))
                        .foregroundColor(.gray)
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

struct ImmuneSectionView: View {
    let immune: [ImmuneDummyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (ImmuneDummyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    var filteredMedication: [ImmuneDummyData] {
        immune.filter { data in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch =   data.vaccineCodeDisplay.localizedCaseInsensitiveContains(searchText)
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
                ForEach(filteredMedication) { labdata in
                    ImmuneMainView(immune: labdata) {
                        onCardTap(labdata)
                    }
                }
            }
            


        }
        .padding(.horizontal)

    }
}
