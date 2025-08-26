//
//  DashboardListFeature.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 11/06/25.
//

import ComposableArchitecture
import Foundation


// MARK: - Category Enum

public enum HealthCategory: String, CaseIterable, Identifiable, Equatable {
    case allergy = "Allergy Intolerance"
    case appointment = "Appointment"
    case claim = "Claim"
    case consents = "Consents"
    case conditions = "Conditions"
    case immunization = "Immunization"
    case labs = "Labs"
    case medications = "Medications"
    case organisation = "Organization"
    case patient = "Patient"
    case providers = "Providers"
    case practioner = "Practitioner"
    case procedure = "Procedure"
    case uploads = "Uploads"
    case vitals = "Vitals"
   
    public var id: String { rawValue }
}


struct DashboardListFeature: Reducer {
    struct State: Equatable {
        var selectedCategory: HealthCategory?

    }

    enum Action: Equatable {
        case onAppear
        case categoryTapped(HealthCategory)
        case categoryDetailDismissed
    }
    
    @Dependency(\.fhirClient) var fhirClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .none

            case .categoryTapped(let category):
                print("Tapped: \(category)") // See if this prints!
                state.selectedCategory = category
                return .none

            case .categoryDetailDismissed:
                state.selectedCategory = nil
                return .none
            }
        }
    }
}

