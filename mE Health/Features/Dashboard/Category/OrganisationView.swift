//
//  OrganisationView.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 11/06/25.
//

import SwiftUI
import ComposableArchitecture

struct OrganisationView: View {
    
    let store: StoreOf<LabObservationFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Organization...")
                    } else {
                        
//                        let issueObj = viewStore.labModel?.entry?.first?.resource?.issue?.first
//                        let name = issueObj?.code ?? "Unknown"  //
//                        let codeLoin = issueObj?.details?.coding?.first?.code ?? ""

                        VStack(alignment: .leading, spacing: 16) {
                            Text("No Organization Data Found")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
//                            
//                            conditionRow(title: "organizationId", value: "", icon: "lungs.fill")
//                            conditionRow(title: "name", value: "Jessica argonaut", icon: "calendar.badge.clock")
//                            conditionRow(title: "address", value: "1979 Milky Way\r\nVerona WI 53593-9179\r\nUnited States of America", icon: "waveform.path.ecg")
//                            conditionRow(title: "telecom", value: "555-555-5555", icon: "calendar")
//                            conditionRow(title: "type", value: "", icon: "info.circle")
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                        .padding()
                    }
                }
                .navigationTitle("Organization")
            }
            .onAppear {
                viewStore.send(.loadLabObservation)
            }

        }
    }

    @ViewBuilder
    private func conditionRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 4)
    }
}



