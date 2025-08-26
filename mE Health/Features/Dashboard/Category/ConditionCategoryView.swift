//
//  ConditionCategoryView.swift
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
//# ============================================================================= on 22/05/25.
//

import SwiftUI
import ComposableArchitecture


struct ConditionCategoryView: View {
    
    let store: StoreOf<ConditionFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Condition...")
                    } else {
                        
                        let respourceObj = viewStore.conditionModel?.entry?.first?.resource
                        let name = respourceObj?.code?.text ?? "Unknown"  //
                        let onsetDate = respourceObj?.onsetDateTime ?? "Unknown"
                        let status = respourceObj?.clinicalStatus?.text ?? "Unknown"
                        let recordedDate = respourceObj?.recordedDate ?? "Unknown"

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Condition Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "Diagnosis", value: name, icon: "lungs.fill")
                            conditionRow(title: "Onset Date", value: onsetDate, icon: "calendar.badge.clock")
                            conditionRow(title: "Status", value: status, icon: "waveform.path.ecg")
                            conditionRow(title: "Recorded Date", value: recordedDate, icon: "calendar")
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
                .navigationTitle("Condition")
            }
            .onAppear {
                viewStore.send(.loadCondition)  
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

#Preview {
    ConditionCategoryView(
        store: Store(
            initialState: ConditionFeature.State(),
            reducer: {
                ConditionFeature()
            }
        )
    )
}
