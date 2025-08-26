//
//  BillingView.swift
//  mE Health
//
//  Created by Rashida on 23/06/25.
//

import SwiftUI
import Foundation

struct ClaimResponse: Codable {
    let claims: [BillingItem]
}


struct BillingItem: Identifiable, Equatable, Codable {
    var id: String { claimId }
    let claimId: String
    let totalAmount: Double
    let totalCurrency: String
    let status: String
    let createdDate: String
    let insuranceRaw: String
    let patientId: String
    let organizationId: String
    let createdAt: String
    let updatedAt: String
    
    var formattedCreatedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: createdDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return createdDate
    }

    enum CodingKeys: String, CodingKey {
        case claimId, totalAmount, totalCurrency, status, createdDate
        case insuranceRaw = "insurance"
        case patientId, organizationId, createdAt, updatedAt
    }

    // Computed property to decode `insurance` JSON string
    var insurance: InsuranceInfo? {
        guard let data = insuranceRaw.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(InsuranceInfo.self, from: data)
    }
}

struct InsuranceInfo: Codable {
    let sequence: Int
    let focal: Bool
    let coverage: CoverageReference
}

struct CoverageReference: Codable {
    let reference: String
    let display: String
}


struct BillingCardView: View {
    let claim: BillingItem
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // Gradient strip on the left
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: Constants.API.PrimaryColorHex),Color(hex: Constants.API.PrimaryColorHex)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 8)
            .cornerRadius(2, corners: [.topRight, .bottomRight]) // optional for smoother right edge

            // Main card content
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(claim.insurance?.coverage.display ?? "Unknown")
                            .font(.montserrat(18, weight: .bold))
                            .foregroundColor(.black)

                        Text(claim.formattedCreatedDate)
                             .font(.montserrat(16, weight: .regular))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        // This VStack has trailing alignment for the pill
                        VStack(spacing: 4) {
                            Text(claim.status.uppercased())
                                .font(.montserrat(12, weight: .semibold))
                                .foregroundColor(Color(hex: "F09C00"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "F09C00").opacity(0.1))
                                .cornerRadius(12)

                            // Center the amount inside the width of the pill above
                            Text("$\(formatAmount(claim.totalAmount))")
                                .font(.montserrat(16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .fixedSize() // Ensures it only takes as much space as needed
                    }
                }
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onTapGesture {
            onTap()
        }

    }
    
    func formatAmount(_ amount: Double) -> String {
        String(format: "%.2f", amount)
    }


}

struct BillingSectionView: View {
    let items: [BillingItem]
    let searchText: String
    let startDate: Date?
    let endDate: Date?
    let selectedFilters: [FilterType]
    var onCardTap: (BillingItem) -> Void
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }

    
    var filteredAppointments: [BillingItem] {
        items.filter { claim in
            // 1. Filter by search text if available
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                matchesSearch = claim.insurance?.coverage.display.localizedCaseInsensitiveContains(searchText) ?? false
            }
            
            let matchesDate: Bool = {
                guard let start = startDate, let end = endDate else { return true }
                if let createdDate = dateFormatter.date(from: claim.createdAt) {
                    return (createdDate >= start) && (createdDate <= end)
                }
                return false
            }()
            
            // 3. Filter by status (skip "All")
            let activeFilters = selectedFilters.filter { $0.label != "All" }
            let matchesStatus: Bool = activeFilters.isEmpty || activeFilters.contains {
                $0.label.lowercased() == claim.status.lowercased()
            }

            return matchesSearch && matchesDate && matchesStatus

        }
    }


    
    var body: some View {
        VStack(spacing: 20) {
            
            if filteredAppointments.isEmpty {
                        NoDataView()
            } else {
                ForEach(filteredAppointments) { item in
                    BillingCardView(claim: item) {
                        onCardTap(item)
                    }
                }
            }

        }
        .padding(.horizontal)
    }

}

