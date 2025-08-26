//
//  AlreadyMeUserFeature.swift
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
//# ============================================================================= on 9/05/25.
//

import ComposableArchitecture
import Foundation

struct AlreadyMeUserFeature: Reducer {
    struct State: Equatable {
        var email: String = ""
        var showValidationErrors: Bool = false
        var isLoading: Bool = false
        var alertMessage: String?
        var showAlert: Bool = false
        var navigateBackToLogin: Bool = false
    }
    

    enum Action: Equatable {
        case emailChanged(String)
        case sendTapped
        case showAlert(String)
        case dismissAlert
        case navigateBackToLoginTapped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .emailChanged(email):
            state.email = email
            state.showValidationErrors = false
            return .none

        case .sendTapped:
            state.showValidationErrors = true
            guard isValidEmail(state.email) else {
                return .none
            }
            state.isLoading = true
            // Simulate API call delay
            return .run { send in
                try await Task.sleep(nanoseconds: 1_000_000_000)
                await send(.showAlert("Password reset link sent."))
            }

        case let .showAlert(message):
            state.isLoading = false
            state.alertMessage = message
            state.showAlert = true
            return .none

        case .dismissAlert:
            state.showAlert = false
            return .none

        case .navigateBackToLoginTapped:
            return .none
        }
    }

    private func isValidEmail(_ input: String) -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            .evaluate(with: trimmed)
    }
}
