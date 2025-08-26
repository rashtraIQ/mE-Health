//
//  PatientProfileFeature.swift
//  mE Health
//
//  Created by Ishant on 13/06/25.
//

import ComposableArchitecture
import Foundation

struct PatientProfileCancelID: Hashable {}

struct PatientProfileFeature: Reducer {
    struct State: Equatable {
        var isMarried: Bool = false
    }

    enum Action: Equatable {
        case toggleMarried(Bool)
    }

   

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case let .toggleMarried(value):
            state.isMarried = value
            return .none
        }
    }
}

