//
//  ImmunisationView.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 12/06/25.
//

import SwiftUI
import ComposableArchitecture

struct ImmunisationView: View {
    
    let store: StoreOf<ImmunisationFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Immunization Data...")
                    }
                    else if viewStore.errorMessage != nil {
                        Text("No Data found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                    }
                    else {
                        
                        let vaccineCode = viewStore.immuneModel?.vaccineCode?.coding?.first?.code ?? ""
                        let occurrenceDateTime = viewStore.immuneModel?.occurrenceDateTime ?? ""
                        let status = viewStore.immuneModel?.status ?? ""
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Immunization Data")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "Vaccine Code:", value: vaccineCode, icon: "calendar.badge.clock")
                            conditionRow(title: "Status:", value: status, icon: "waveform.path.ecg")
                            conditionRow(title: "occurrenceDate:", value: occurrenceDateTime, icon: "calendar")

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
                .navigationTitle("Immunization")
            }
            .onAppear {
                viewStore.send(.loadImmunisation)
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
