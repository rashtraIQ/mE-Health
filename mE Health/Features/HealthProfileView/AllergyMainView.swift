//
//  AllergyMainView.swift
//  mE Health
//
//  Created by Rashida on 17/06/25.
//

import SwiftUI



struct AllergyMainView: View {
    
    let allergy: AllergyData
    let onTap: () -> Void
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(allergy.code?.display ?? "")
                    .font(.montserrat(20, weight: .medium))
                    .foregroundColor(.black)
                Spacer()
                Text("Active")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .clipShape(Capsule())
            }
            .padding(.top,12)
            .padding(.horizontal,12)
            
            Text("Recorded Date: \(allergy.formattedRecordedDate)")
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

struct AllergySectionView: View {
    let allergies: [AllergyData]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (AllergyData) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }
    

    var filteredAllergy: [AllergyData] {
        allergies.filter { allergy in
            // 1. Filter by search
            let matchesSearch: Bool = searchText.isEmpty || allergy.code?.display.localizedCaseInsensitiveContains(searchText) ?? false
            
            // 2. Filter by date
            let matchesDate: Bool = {
                guard let start = startDate, let end = endDate else { return true }
                if let createdDate = dateFormatter.date(from: allergy.createdAt) {
                    return (createdDate >= start) && (createdDate <= end)
                }
                return false
            }()
            
            // 3. Filter by status (skip "All")
            let activeFilters = selectedFilters.filter { $0.label != "All" }
            let matchesStatus: Bool = activeFilters.isEmpty || activeFilters.contains {
                $0.label.lowercased() == allergy.clinicalStatus.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus
        }
    }



    
    var body: some View {
        
        VStack(spacing: 20) {
            // Horizontal date cards
            
            if filteredAllergy.isEmpty {
                    NoDataView()
            } else {
                        
                ForEach(filteredAllergy) { allergy in
                    AllergyMainView(allergy: allergy) {
                        onCardTap(allergy)
                    }
                }
            }
        }
        .padding(.horizontal)

    }
}
