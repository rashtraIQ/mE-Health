//
//  PersonaFeature.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 8/06/25.
//

import ComposableArchitecture
import SwiftUI

enum PersonaDestination: Hashable, Identifiable {
    case patientProfile
    case myHealth

    var id: String {
        switch self {
        case .patientProfile: return "patientProfile"
        case .myHealth: return "myHealth"
        }
    }
}


struct PersonaFeature: Reducer {
    struct State: Equatable {
        var selectedItem: PersonaItem? = nil
        var items: [PersonaItem] = PersonaItem.sampleItems
        var navigateBackToHome: Bool = false
        var selectedDestination: PersonaDestination? = nil
        var patientProfile: PatientProfileFeature.State? = nil
        var selectedMenuTab: SideMenuTab = .dashboard
        var showMenu: Bool = false
        var selectedTab: DashboardTab = .menu

    }

    enum Action: Equatable {
        case itemTapped(PersonaDestination)
        case dismissDestination
        case navigateBackToHomeTapped
        case patientProfile(PatientProfileFeature.Action)
        case dismissPatientProfile
        case tabMenuItemSelected(SideMenuTab)
        case toggleMenu(Bool)
        case tabSelected(DashboardTab)

    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .itemTapped(let destination):
            state.selectedDestination = destination
            return .none

        case .dismissDestination:
            state.selectedDestination = nil
            return .none

        case .navigateBackToHomeTapped:
            return .none

        case .patientProfile:
            return .none

        case .dismissPatientProfile:
            state.patientProfile = nil
            return .none
            
        case .tabSelected(let tab):
            state.selectedTab = tab
            return .none

        case let .toggleMenu(isOpen):
            state.showMenu = isOpen
            return .none

        case .tabMenuItemSelected(let item):
            switch item {

            case .logout:
                SessionManager.shared.clearSession()
                //state.navigationDestination = .login
            default:
                break
            }
            return .none

        }
    }

    var body: some ReducerOf<Self> {
        Reduce(self.reduce)
            .ifLet(\.patientProfile, action: /Action.patientProfile) {
                PatientProfileFeature()
            }
    }
}


struct PersonaItem: Equatable, Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let destination: PersonaDestination

    static let sampleItems: [PersonaItem] = [
        .init(iconName: "PersonalCare", title: "My Profile", destination: .patientProfile),
//        .init(iconName: "familycare", title: "Family"),
//        .init(iconName: "SocialAccount", title: "My Network"),
//        .init(iconName: "Finance", title: "Financial Profile"),
        .init(iconName: "Health", title: "My Health", destination: .myHealth),
//        .init(iconName: "carProfile", title: "Car profile"),
//        .init(iconName: "home_p", title: "Home Profile"),
//        .init(iconName: "Vacations", title: "Vacation Profile"),
//        .init(iconName: "dailyroutine", title: "Daily Routine")
    ]
}
