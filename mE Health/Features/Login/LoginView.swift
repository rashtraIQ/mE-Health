//
//  LoginView.swift
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

import SwiftUI
import ComposableArchitecture



struct LoginView: View {
    let store: StoreOf<LoginFeature>
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    let meColor = "#FF6605"
    let textFieldCornerRadius: CGFloat = 10
    let horizontalPadding: CGFloat = 20
    let secondaryButtonColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    let buttonHeight: CGFloat = 50
    private let registerStore = Store(initialState: RegistrationFeature.State()) {
        RegistrationFeature()
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                   
                        if colorScheme == .dark {
                            GIFView(gifName: "ME")
                                    .frame(width: 133, height: 133)
                                    .padding(.top,83)
                            Text("Welcome")
                                .font(.title2).fontWeight(.semibold)
                                
                                .padding(.top, -30)
                                } else {
                                GIFView(gifName: "mELogo")
                                        .frame(width: 133, height: 133)
                                        .padding(.top,83)
                                    Text("Welcome")
                                        .font(.title2).fontWeight(.semibold)
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                        .padding(.top, -30)
                                }
                        Spacer()
                    
                // Email Field
                        InputField(
                            label: "Email",
                            icon: "personicon",
                            placeholder: "Enter Email",
                            text: viewStore.binding(
                                get: \.email,
                                send: LoginFeature.Action.emailChanged
                            ),
                            isSecure: false,
                            showPassword: .constant(false),
                            showValidation: viewStore.showValidationErrors,
                            validation: Validator.validateEmail

                        )
                        .keyboardType(.emailAddress)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .padding(.top, -20)
                        
                // Password InputField
                        InputField(
                            label: "Password",
                            icon: "lockicon",
                            placeholder: "Enter Password",
                            text: viewStore.binding(
                                get: \.password,
                                send: LoginFeature.Action.passwordChanged
                            ),
                            isSecure: true,
                            showPassword: viewStore.binding(
                                get: \.isPasswordVisible,
                                send: { _ in LoginFeature.Action.togglePasswordVisibility }
                            ),
                            showValidation: viewStore.showValidationErrors,
                            validation: Validator.validatePassword
                        )
                        .focused($isTextFieldFocused)
                        
                        // Forgot?
                        HStack {
                            Button("Forgot?") {
                                viewStore.send(.forgotPasswordTapped)
                            }
                            .font(.footnote)
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .light ? .black : .gray)
                            .padding(.top, -15)
                            Spacer()
                        }
                        .padding(.leading, 0)

                        // Continue Button
                        Button(action: {
                            viewStore.send(.setValidationErrorsVisible(true))
                            viewStore.send(.loginTapped)
                        }) {
                            HStack {
                                if viewStore.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Login")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                }
                            }
                            .fontWeight(.medium)
                            .frame(height: buttonHeight)
                            .frame(maxWidth: .infinity)
                        }
                        .background(Color(hex: meColor))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .disabled(viewStore.isLoading)
//                        .navigationDestination(
//                            store: store.scope(
//                                state: \.$dashboardState,
//                                action: LoginFeature.Action.dashboard
//                            )
//                        ) { dashboardStore in
//                            DashboardView(store: dashboardStore)
//                        }
                        .navigationDestination(
                            isPresented: viewStore.binding(
                                get: \.navigateToDashboard,
                                send: { _ in .dismissDashboardView } // new action to cleanly dismiss
                            )
                        ) {
                            IfLetStore(
                                store.scope(
                                    state: \.dashboardState,
                                    action: LoginFeature.Action.dashboardState
                                )
                            ) { dashboardStore in
                                DashboardView(store: dashboardStore)
                            }
                        }

                        .alert(
                            "STATUS",
                            isPresented: viewStore.binding(
                                get: \.showErrorAlert,
                                send: .dismissErrorAlert
                            )
                        ) {
                                               Button("OK", role: .cancel) {
                                               }
                                           } message: {
                                               Text(viewStore.errorMessage)
                                           }
                        
                        // OR Divider
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.5))
                            Text("Or").font(.headline).foregroundColor(.gray)
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.5))
                        }
                        .padding(.top, 20)
                        
                        // Navigation Buttons
                       // alreadyAUserButton(viewStore: viewStore)
                        signUpPrompt(viewStore: viewStore)
                    }
                    
                    .padding(.horizontal, horizontalPadding)
                    .allowsHitTesting(!viewStore.isLoading)
                }.ignoresSafeArea(.keyboard)
                    .navigationDestination(
                        isPresented: viewStore.binding(
                            get: \.showForgotPassword,
                            send: { _ in .dismissForgotPassword } // new action to cleanly dismiss
                        )
                    ) {
                        IfLetStore(
                            store.scope(
                                state: \.forgotPasswordState,
                                action: LoginFeature.Action.forgotPassword
                            )
                        ) { forgotPasswordStore in
                            ForgotPasswordView(store: forgotPasswordStore)
                        }
                    }

                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            }
            .onAppear {
                            viewStore.send(.onAppear)
                        }
            .alert(
                isPresented: viewStore.binding(
                    get: \.showErrorAlert,
                    send: .dismissErrorAlert
                )
            ) {
                Alert(title: Text("Login Failed"), message: Text(viewStore.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: – Navigation Buttons
    private func alreadyAUserButton(viewStore: ViewStoreOf<LoginFeature>) -> some View {
        Button(action: {
            viewStore.send(.navigateToAlreadyAUserTapped)
        }) {
            (Text("Already a ")
             + Text("mE").foregroundColor(Theme.primary)
             + Text(" User"))
                .fontWeight(.medium)
                .frame(height: buttonHeight)
                .frame(maxWidth: .infinity)
        }
        .background(secondaryButtonColor)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding(.vertical)
        .navigationDestination(
            isPresented: viewStore.binding(
                get: \.navigateToAlreadyAUser,
                send: LoginFeature.Action.navigateToAlreadyAUserTapped
            )
        ) {
            IfLetStore(
                store.scope(
                    state: \.alreadyUserState,
                    action: LoginFeature.Action.alreadyUserState
                )
            ) { alreadyUserStore in
                AlreadyMeUserView(store: alreadyUserStore)
            }

        }
    }

    private func signUpPrompt(viewStore: ViewStoreOf<LoginFeature>) -> some View {
        HStack(spacing: 5) {
            Text("Don't have an account?").foregroundColor(.gray)
            Button(action: {
                viewStore.send(.navigateToRegisterTapped)
            }) {
                Text("Sign up")
                    .fontWeight(.medium)
                    .foregroundColor(Theme.primary)
            }
        }
        .font(.headline)
        .navigationDestination(
            isPresented: viewStore.binding(
                get: \.navigateToRegister,
                send: LoginFeature.Action.navigateToRegisterTapped
            )
        ) {
            RegistrationView1(store: registerStore) 
        }
    }

}

#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State(),
            reducer: {
                LoginFeature()
            }
        )
    )
}

