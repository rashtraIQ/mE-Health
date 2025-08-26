//
//  LoginFeature.swift
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
//# ============================================================================= on 7/05/25.
//

import ComposableArchitecture
import Foundation

struct LoginFeature: Reducer {
    struct State: Equatable {
        var email = ""
        var password = ""
        var isPasswordVisible = false
        var showValidationErrors = false
        var showErrorAlert = false
        var errorMessage = ""
        var navigateToRegister = false
        var navigateToAlreadyAUser = false
        var isLoading = false
        var showForgotPassword = false
        var forgotPasswordState: ForgotPasswordFeature.State? = nil
        var alreadyUserState: AlreadyMeUserFeature.State? = nil
        var navigateToDashboard = false
        var authError: String?
        var isLoggedIn = false
        var dashboardState: DashboardFeature.State? = nil
        var userData : UserData?
    }
    
    @Dependency(\.loginClient) var loginClient
    @Dependency(\.authService) var authService
    
    enum Action: Equatable {
        case emailChanged(String)
        case passwordChanged(String)
        case togglePasswordVisibility
        case loginTapped
        case navigateToRegisterTapped
        case navigateToAlreadyAUserTapped
        case dismissErrorAlert
        case setValidationErrorsVisible(Bool)
        case loginResponse(TaskResult<LoginResponse>)
        case forgotPasswordTapped
        case dismissForgotPassword
        case forgotPassword(ForgotPasswordFeature.Action)
        case alreadyUserState(AlreadyMeUserFeature.Action)
//        case oauthResponse(Result<URL, AuthError>)
//        case tokenExchangeResponse(Result<TokenExchangeResult, AuthError>)
        case dismissDashboardView
        case dashboardState(DashboardFeature.Action)
        case onAppear


    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        case .onAppear:
            print("on appear")
            return .none
            

        case .emailChanged(let email):
            print("Email changed to:", email)
            state.email = email
            state.showValidationErrors = false
            return .none

        case .passwordChanged(let password):
            print("password changed to:", password)
            state.password = password
            state.showValidationErrors = false
            return .none

        case .togglePasswordVisibility:
            state.isPasswordVisible.toggle()
            return .none

        case .loginTapped:
            state.showValidationErrors = true
            let isValidEmail = NSPredicate(
                format: "SELF MATCHES %@",
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            ).evaluate(with: state.email)

            guard isValidEmail, state.password.count >= 8 else {
                return .none // don't show alert
            }

            state.isLoading = true
            let request = LoginRequest(email: state.email, password: state.password, firebase_token: "", user_type: "seller")
            return .run { send in
                do {
                        let response = try await loginClient.login(request)
                        await send(.loginResponse(.success(response)))
                    } catch {
                        await send(.loginResponse(.failure(error)))
                    }
            }

        case let .loginResponse(.success(response)):
            print(response)
            
            let userData = response.data
            state.userData = userData
            let token = userData?.token ?? ""
            let user_id = userData?.user_id ?? 0
            state.isLoading = false
            MEUtility.setME_TOKEN(value: token)
            MEUtility.setME_USERID(value: String(user_id))
            SessionManager.shared.saveLoginSession()
            state.isLoggedIn = true
            state.dashboardState = DashboardFeature.State()
            state.navigateToDashboard = true
            return .none
            
        case let .loginResponse(.failure(error)):
            state.isLoading = false
            state.isLoggedIn = false
            state.navigateToDashboard = false
            state.showErrorAlert = true
            state.errorMessage = "Login failed: \(error.localizedDescription)"
            return .none


        case .forgotPasswordTapped:
            state.showForgotPassword = true
            state.forgotPasswordState = ForgotPasswordFeature.State()
            return .none

        case .dismissForgotPassword:
            state.showForgotPassword = false
            return .none

        case .navigateToRegisterTapped:
            state.navigateToRegister = true
            return .none

        case .navigateToAlreadyAUserTapped:
            state.navigateToAlreadyAUser = true
            state.alreadyUserState = AlreadyMeUserFeature.State()
            return .none

        case .dismissErrorAlert:
            state.showErrorAlert = false
            return .none
            
        case .setValidationErrorsVisible(let isVisible):
            state.showValidationErrors = isVisible
            return .none
            
        case .forgotPassword(.navigateBackToLoginTapped):
            state.showForgotPassword = false
            state.forgotPasswordState = nil
            return .none
            
        case .alreadyUserState(.navigateBackToLoginTapped):
            state.navigateToAlreadyAUser = false
            state.alreadyUserState = nil
            return .none
           
        case .dismissDashboardView:
            state.navigateToDashboard = false
            state.dashboardState = nil
            return .none

        case .forgotPassword(.emailChanged(_)):
            return .none
        case .forgotPassword(.sendTapped):
            return .none
        case .forgotPassword(.showAlert(_)):
            return .none
        case .forgotPassword(.dismissAlert):
            return .none
        case .alreadyUserState(.emailChanged(_)):
            return .none
        case .alreadyUserState(.sendTapped):
            return .none
        case .alreadyUserState(.showAlert(_)):
            return .none
        case .alreadyUserState(.dismissAlert):
            return .none
        case .dashboardState(let dashboardAction):
            // Forward dashboard actions to the dashboard reducer
            guard var dashboardState = state.dashboardState else { return .none }
            let effect = DashboardFeature().reduce(into: &dashboardState, action: dashboardAction)
            state.dashboardState = dashboardState
            return effect.map(Action.dashboardState)

        }
    }
    
    private func extractCode(from url: URL) -> String? {
            URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "code" })?
                .value
    }
    
    var body: some ReducerOf<Self> {
        Reduce(self.reduce)
            .ifLet(\.forgotPasswordState, action: /Action.forgotPassword) {
                ForgotPasswordFeature()
            }
        
            .ifLet(\.alreadyUserState, action: /Action.alreadyUserState) {
                AlreadyMeUserFeature()
            }
            .ifLet(\.dashboardState, action: /Action.dashboardState) {
                DashboardFeature()
            }
    }

}

