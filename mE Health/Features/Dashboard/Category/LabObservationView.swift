//
//  LabObservationView.swift
//  mE Health
//
//  # =============================================================================
//# mEinstein - CONFIDENTIAL
//#
//# Copyright ©️ 2025 mEinstein Inc. All Rights Reserved.
//#
//# NOTICE: All information contained herein is and remains the property of
//# mEinstein Inc. The intellectual and technical concepts contained herein are
//# proprietary to mEinstein Inc. and may be covered by U.S. and foreign patents,
//# patents in process, and are protected by trade secret or copyright law.
//#
//# Dissemination of this information, or reproduction of this material,
//# is strictly forbidden unless prior written permission is obtained from
//# mEinstein Inc.
//#
//# Author(s): Ishant 
//# ============================================================================= on 23/05/25.
//

import SwiftUI
import ComposableArchitecture

struct LabObservationView: View {
    
    let store: StoreOf<LabObservationFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Lab Observation...")
                    } else {
                        
                        let issueObj = viewStore.labModel?.entry?.first?.resource?.issue?.first
                        let name = issueObj?.code ?? "Unknown"  //
                        let codeLoin = issueObj?.details?.coding?.first?.code ?? ""

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Lab Observation Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "LadId", value: "f594liZecm9LvIpQLI.QS9Q4", icon: "lungs.fill")
                            conditionRow(title: "code", value: "27574-3", icon: "calendar.badge.clock")
                            conditionRow(title: "description", value: "Skilled nursing treatment plan Progress note and attainment of goals (narrative)", icon: "lungs.fill")
                            conditionRow(title: "result", value: "Signs and Symptoms of listed potential physiological problem will be absent or manageable.", icon: "calendar")
                            conditionRow(title: "effectiveDate", value: "", icon: "info.circle")
                            conditionRow(title: "status", value: "final", icon: "lungs.fill")
                            conditionRow(title: "performer", value: "", icon: "calendar.badge.clock")
                            
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
                .navigationTitle("Lab Observation")
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


struct VitalObservationView: View {
    
    let store: StoreOf<VitalsObservationFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Vital Observation...")
                    } else {
                        
                        
                        let issueObj = viewStore.vitalModel?.entry?.first?.resource?.issue?.first
                        let name = issueObj?.code ?? "Unknown"  //
                        let codeLoin = issueObj?.details?.coding?.first?.code ?? ""

                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Vital Observation Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "Test Name", value: name, icon: "lungs.fill")
                            conditionRow(title: "Value", value: "Not Available", icon: "calendar.badge.clock")
                            conditionRow(title: "Units", value: "Not Available", icon: "waveform.path.ecg")
                            conditionRow(title: "Date", value: "Not Available", icon: "calendar")
                            conditionRow(title: "LOINC Code", value: codeLoin, icon: "info.circle")
                            conditionRow(title: "Normal Range", value: "Not Available", icon: "info.circle")
                            conditionRow(title: "Interpretation", value: "Not Available", icon: "info.circle")
                            conditionRow(title: "Source", value: "Not Available", icon: "info.circle")
                            
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
                .navigationTitle("Vital Observation")
            }
            .onAppear {
                viewStore.send(.loadVitalbservation)
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
