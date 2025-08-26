//
//  DeleteAccountView.swift
//  mE Health
//
//  Created by Rashida on 24/07/25.
//

import SwiftUI
import ComposableArchitecture

struct DeleteAccountView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var reasonsFromAPI: [deleteReasonData] = []
    @State private var selectedReasonID: Int?
    @State private var selectedReasonName: String = ""
    @State private var otherReason: String = ""

    @State private var isLoading = false

    @Dependency(\.deleteClient) var deleteClient
    @State private var isSubmittingDelete = false

    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var navigateToSettings = false
    @State private var navigateToContact = false
    
    @State private var navigateToLogin = false
    

    @State private var showConfirmPopup = false
    @State private var confirmText = ""
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    
    var body: some View {
        
        MainLayout(
            selectedTab: $selectedTab,
            showMenu: $showMenu,
            selectedMenuTab: selectedMenuTab,
            onMenuItemTap: { tab in
                selectedMenuTab = tab
                showMenu = false
                
                // Optional: route or update state
                if tab == .dashboard {
                    navigateToDashboard = true
                    
                }
                else if tab == .persona {
                    navigateToPersona = true
                }
                
                else if tab == .settings {
                    navigateToSettings = true
                }

                
                else if tab == .contact {
                    navigateToContact = true
                }
                else if tab == .logout {
                    
                }

            }
            ,
            onDashboardTabTapped: {
                    navigateToDashboard = true
                }
        )
        {
            
            ZStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        CustomBackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Text("Delete account")
                        .font(.montserrat(37, weight: .bold))
                        .padding(.top, 24)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            HStack {
                                Spacer()
                                Image("delete_placeholder") // Replace with your custom image
                                    .resizable()
                                    .frame(width: 280, height: 210)
                                    .foregroundColor(.orange)
                                    .padding(.top)
                                Spacer()
                            }
                            
                            Spacer(minLength: 16)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text("Delete account")
                                    .font(.montserrat(20, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Before you go, can you tell us why you’re leaving? Your feedback helps us improve.\nReasons (select one):")
                                     .font(.montserrat(16, weight: .regular))
                                    .foregroundColor(.gray)
                                
                            }
                            
                            Spacer(minLength: 8)
                            
                            if isLoading {
                                VStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                        .scaleEffect(1.5)
                                    Spacer()
                                }
                                .frame(height: 120)  // Set to your desired height
                                .frame(maxWidth: .infinity)

                            }
                            else {
                                
                                ForEach(reasonsFromAPI, id: \.id) { reason in
                                    HStack(spacing: 8) {
                                        Image(selectedReasonID == reason.id ? "radio_select" : "radio_deselect")

                                        Text(reason.name ?? "")
                                            .font(.montserrat(16, weight: .medium))
                                            .onTapGesture {
                                                selectedReasonID = reason.id
                                                selectedReasonName = reason.name ?? ""
                                            }

                                        Spacer()
                                    }
                                }
                            }
                            // Show text field if "Other" is selected
                            if selectedReasonName == "Others" {

                                TextField("Enter the reason here", text: $otherReason)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 1)
                                        
                                    )
                                    .padding(.horizontal, 24)
                                    .doneToolbar()
                            }
                        }
                        
                        Spacer(minLength: 32)
                        
                        // Delete button
                        Button(action: {
                            
                            showConfirmPopup = true
                            
                            // Handle delete action
                        }) {
                            Text("Delete Account")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.montserrat(16, weight: .bold))
                                .background(
                                    (selectedReasonID != nil && (selectedReasonName != "Others" || !otherReason.isEmpty))
                                        ? Color(hex: Constants.API.PrimaryColorHex)
                                        : Color.gray
                                )

                                .cornerRadius(30)
                        }
                        .disabled(selectedReasonID == nil || (selectedReasonName == "Others" && otherReason.isEmpty))

                        
                        Spacer(minLength: 24)
                    }
                    .padding(.bottom, 100)
                }
                .padding(.horizontal)
                .padding(.top, 0)
                .padding(.bottom, 32)
                .disabled(showConfirmPopup)
                .disabled(isLoading)
                
                

                // Confirmation Popup Overlay
                if showConfirmPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Deleting Account Permanently")
                            .font(.montserrat(16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Deleting your account will ")
                        + Text("permanently erase all your registration information")
                            .font(.montserrat(16, weight: .medium))
                            .foregroundColor(.red)

                        + Text(" from our system. This cannot be undone.")
                            .font(.montserrat(16, weight: .medium))
                        
                        
                        Text("To Confirm this, type ")
                            .font(.montserrat(8, weight: .medium))
                        + Text("\"DELETE\"")
                            .foregroundColor(.red)
                            .font(.montserrat(8, weight: .medium))
                        
                        
                        HStack {
                            
                            TextField("", text: $confirmText)
                                .padding(.horizontal, 12)
                                .frame(height: 40) // Set fixed height
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            
                            

                            Spacer()
                            
                            Button(action: {
//                                if confirmText == "DELETE" {
//                                    showConfirmPopup = false
//                                }
                                guard confirmText == "DELETE", let reasonID = selectedReasonID else { return }
                                let finalFeedback = selectedReasonName == "Others" ? otherReason : ""

                                let request = DeleteRequest(
                                    reason: reasonID,
                                    source: selectedReasonName,
                                    satisfaction_rating: 3,
                                    additional_feedback: finalFeedback,
                                    current_password: ""
                                )
                                
                                Task {
                                    isSubmittingDelete = true
                                    
//                                    SessionManager.shared.clearSession()
//                                    TokenManager.deleteAccessToken()
//                                    AuthService.clearExpiryTimestamp()
//                                    MEUtility.setME_PATIENTID(value: "")
//
//                                    DispatchQueue.main.async {
//                                        navigateToLogin = true
//                                    }
                                    do {
                                        let response = try await deleteClient.postDeleteApi(request)
                                        print("Delete response:", response)

                                        if response.status == 200 {

                                            SessionManager.shared.clearSession()
                                            TokenManager.deleteAccessToken()
                                            AuthService.clearExpiryTimestamp()
                                            MEUtility.setME_PATIENTID(value: "")

                                            DispatchQueue.main.async {
                                                navigateToLogin = true
                                            }
                                        } else {
                                            errorMessage = response.mE_text_res ?? "Failed to delete account.status - \(response.status ?? 400)"
                                            showErrorAlert = true
                                        }
                                    } catch {
                                        errorMessage = "Failed to delete account.status - 500"
                                        showErrorAlert = true
                                    }
                                    
                                    isSubmittingDelete = false
                                }


                            }) {
                                Text("Delete Account")
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .padding(.horizontal, 16)
                                    .font(.montserrat(10, weight: .semibold))
                                    .background(Color(hex: Constants.API.PrimaryColorHex))
                                    .cornerRadius(24)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal, 30)
                }
                


            }
            navigationLinks()

        }
        .onAppear {
            Task {
                isLoading = true
                do {
                    let response = try await deleteClient.getReasonList()
                    reasonsFromAPI = response.data ?? []
                } catch {
                    print("Error fetching delete reasons: \(error)")
                }
                isLoading = false
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        
        NavigationLink(
            destination: DashboardView(
                store: Store(
                    initialState: DashboardFeature.State(),
                    reducer: { DashboardFeature() }
                )
            ),
            isActive: $navigateToDashboard
        ) {
            EmptyView()
        }

        NavigationLink(
            destination: PersonaView(
                store: Store(
                    initialState: PersonaFeature.State(),
                    reducer: { PersonaFeature() }
                )
            ),
            isActive: $navigateToPersona
        ) {
            EmptyView()
        }
        
        NavigationLink(
            destination: SettingView(),
            isActive: $navigateToSettings
        ) {
            EmptyView()
        }
  
        NavigationLink(
            destination: ContactUsView(),
            isActive: $navigateToContact
        ) {
            EmptyView()
        }

        NavigationLink(
            destination: LoginView(
                store: Store(
                    initialState: LoginFeature.State(),
                    reducer: { LoginFeature() }
                )
            ),
            isActive: $navigateToLogin
        ) {
            EmptyView()
        }


    }
}

#Preview {
    DeleteAccountView()
}
