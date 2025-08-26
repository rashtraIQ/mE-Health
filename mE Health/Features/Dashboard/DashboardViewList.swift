//
//  DashboardViewList.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 11/06/25.
//


import SwiftUI
import ComposableArchitecture

struct DashboardViewList: View {
    let store: StoreOf<DashboardListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {

                    List {
                        ForEach(HealthCategory.allCases) { category in
                            Button {
                                viewStore.send(.categoryTapped(category))
                            } label: {
                                Text(category.rawValue)
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                    .navigationTitle("Health Record")
                    .sheet(
                        item: Binding(
                            get: { viewStore.selectedCategory },
                            set: { _ in viewStore.send(.categoryDetailDismissed) }
                        )
                    ) { category in
                        destinationView(for: category)
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
        
        @ViewBuilder
        private func destinationView(for category: HealthCategory) -> some View {
            switch category {
            case .providers:
                ProviderCategoryView(
                    store: Store(
                        initialState: ProviderCategoryFeature.State(),
                        reducer: {
                            ProviderCategoryFeature()
                        }
                    )
                )
            case .conditions:
                ConditionCategoryView(
                    store: Store(
                        initialState: ConditionFeature.State(),
                        reducer: {
                            ConditionFeature()
                        }
                    )
                )
            case .medications:
                MedicationCategoryView(
                    store: Store(
                        initialState: MedicationFeature.State(),
                        reducer: {
                            MedicationFeature()
                        }
                    )
                )
            case .labs:
                LabObservationView(
                    store: Store(
                        initialState: LabObservationFeature.State(),
                        reducer: {
                            LabObservationFeature()
                        }
                    )
                )
            case .vitals:
                VitalObservationView(
                    store: Store(
                        initialState: VitalsObservationFeature.State(),
                        reducer: {
                            VitalsObservationFeature()
                        }
                    )
                )
            case .uploads:
                DocumentReferenceView(
                    store: Store(
                        initialState: ConsentFeature.State(),
                        reducer: {
                            ConsentFeature()
                        }
                    )
                )
            case .consents:
                ConsentView(
                    store: Store(
                        initialState: ConsentFeature.State(),
                        reducer: {
                            ConsentFeature()
                        }
                    )
                )
            case .allergy:
                ConsentView(
                    store: Store(
                        initialState: ConsentFeature.State(),
                        reducer: {
                            ConsentFeature()
                        }
                    )
                )
            case .organisation:
                OrganisationView(
                    store: Store(
                        initialState: LabObservationFeature.State(),
                        reducer: {
                            LabObservationFeature()
                        }
                    )
                )
                
            case .practioner:
                PractionerView(
                    store: Store(
                        initialState: PractionerFeature.State(),
                        reducer: {
                            PractionerFeature()
                        }
                    )
                )
                
            case .appointment:
                AppoitmentView(
                    store: Store(
                        initialState: AppoitmentFeature.State(),
                        reducer: {
                            AppoitmentFeature()
                        }
                    )
                )
            case .procedure:
                ConsentView(
                    store: Store(
                        initialState: ConsentFeature.State(),
                        reducer: {
                            ConsentFeature()
                        }
                    )
                )
                
            case .immunization:
                ImmunisationView(
                    store: Store(
                        initialState: ImmunisationFeature.State(),
                        reducer: {
                            ImmunisationFeature()
                        }
                    )
                )
            case .claim:
                ConsentView(
                    store: Store(
                        initialState: ConsentFeature.State(),
                        reducer: {
                            ConsentFeature()
                        }
                    )
                )
            case .patient:
                PatientView(
                    store: Store(
                        initialState: PatientFeature.State(),
                        reducer: {
                            PatientFeature()
                        }
                    )
                )
            }
        }
        
    }
    

    
    
    #Preview {
        DashboardViewList(
            store: Store(
                initialState: DashboardListFeature.State(),
                reducer: {
                    DashboardListFeature()
                }
            )
        )
    }
    
    
