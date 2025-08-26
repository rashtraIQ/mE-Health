//
//  ProviderCategoryView.swift
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

struct ProviderCategoryView: View {
    
    let store: StoreOf<ProviderCategoryFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Providers...")
                    } else {
                        
//                        let name = viewStore.patient?.name?.first?.text ?? "Unknown"  //
//                        let speciality = viewStore.practitioner?.display ?? "Unknown"
                        VStack(alignment: .leading, spacing: 16) {
                            Text("No Data Found")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)

//                            providerRow(title: "Name", value: name, icon: "person.fill")
//                            providerRow(title: "Specialty", value: speciality, icon: "stethoscope")
//                            providerRow(title: "Last Visit", value: "Oct 15, 2024", icon: "calendar.badge.clock")

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
                .navigationTitle("Providers")

            }
            .onAppear {
                viewStore.send(.loadProviders)
            }
        }
    }

    @ViewBuilder
    private func providerRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
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
        ProviderCategoryView(
            store: Store(
                initialState: ProviderCategoryFeature.State(),
                reducer: {
                    ProviderCategoryFeature()
                }
            )
        )
}
