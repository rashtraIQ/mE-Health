//
//  ContactUsView.swift
//  mE Health
//
//  Created by Rashida on 23/07/25.
//

import SwiftUI
import ComposableArchitecture

struct ContactUsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showSubjectSheet = false
    @State private var selectedSubject = ""
    @State private var commentText = ""
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var navigateToSettings = false
    
    @State private var isSubjectPopupPresented = false
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    @Dependency(\.contactUsClient) var contactUsClient
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    

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

                
            }
            ,
            onDashboardTabTapped: {
                    navigateToDashboard = true
                }
        )
        {
            GeometryReader { geometry in
                let primaryColor = Color(hex: Constants.API.PrimaryColorHex)

                ZStack(alignment: .topLeading) {
                    Color.white.ignoresSafeArea()

                    // Top orange bar
                    primaryColor
                        .frame(height: 64)
                        .ignoresSafeArea(edges: .top)

                    // Top right orange circle
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 270, height: 270)
                        .offset(x: geometry.size.width - 160, y: -180)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Spacer().frame(height: 24)
                            
                            HStack {
                                CustomBackButton {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                Spacer()
                            }
                            .padding(.top, 0)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                // Header Text
                                Text("Contact Us")
                                   .font(.montserrat(32, weight: .bold))
                                    .foregroundColor(.black)

                                Text("We’d love to hear from you, please\n drop us a line if you’ve any query.")
                                    .font(.montserrat(16, weight: .medium))
                                    .foregroundColor(.gray)

                            }

                            // Center Image Group
                            HStack(spacing: 16) {
                                Image("contact") // replace with your asset names
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text("Hii \(userProfileData?.first_name ?? "")")
                                   .font(.montserrat(32, weight: .bold))

                                Text("Let us know how we can assist you today!")
                                    .font(.montserrat(14, weight: .medium))
                                    .foregroundColor(.gray)

                            }
                            
                            Spacer().frame(height: 8)
                            

                            // Subject Field
                            Button(action: {
                                isSubjectPopupPresented = true
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Subject")
                                        .font(.montserrat(12, weight: .semibold))
                                        .foregroundColor(.black)

                                    HStack(spacing: 8) {
                                        Image("leading_icon")
                                            .foregroundColor(primaryColor)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(selectedSubject)
                                                 .font(.montserrat(14, weight: .regular))
                                                .foregroundColor(.black)

                                            Rectangle()
                                                .fill(primaryColor)
                                                .frame(height: 1)


                                        }
                                        
                                        Spacer()
                                        
                                    }

                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Comments")
                                    .font(.montserrat(12, weight: .semibold))
                                    .foregroundColor(.black)

                                HStack(alignment: .top, spacing: 8) {
                                    Image("msg_icon")
                                        .padding(.top, 8)

                                    ZStack(alignment: .topLeading) {
                                        // Placeholder
                                        if commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text("Enter your thoughts here")
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 12)
                                                .font(.montserrat(14, weight: .regular))
                                        }

                                        // TextEditor
                                        TextEditor(text: $commentText)
                                            .padding(4)
                                            .background(Color.clear)
                                            .frame(height: 100)
                                            .font(.montserrat(14, weight: .regular))
                                            .foregroundColor(.black)
                                            .scrollContentBackground(.hidden) // hides default background (iOS 16+)
                                            .doneToolbar()
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            
                            Spacer().frame(height: 32)

                            // Send Button
                            Button(action: {
                                Task {
                                        await sendContactUs()
                                    }
                            }) {
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hex: Constants.API.PrimaryColorHex))
                                        .cornerRadius(28)
                                } else {
                                    Text("Send")
                                        .foregroundColor(.white)
                                        .font(.montserrat(16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedSubject.isEmpty ? Color.gray : Color(hex: Constants.API.PrimaryColorHex))
                                        .cornerRadius(28)
                                }

                            }
                            .disabled(selectedSubject.isEmpty || isLoading)

                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 0)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom) 
                    .padding(.bottom, 100)
                    navigationLinks()
                }
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: isSubjectPopupPresented) { isPresented in
                     if isPresented {
                         viewControllerHolder?.present(
                             style: .overCurrentContext,
                             transitionStyle: .crossDissolve
                         ) {
                             SubjectPopUpView(
                                             selectedSubject: $selectedSubject,
                                             onDismiss: {
                                                 isSubjectPopupPresented = false // Reset the flag here
                                             }
                                         )
                         }
                     }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Contact Us"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }


        }
        
    }
    
    @MainActor
    private func sendContactUs() async {
        guard let user = userProfileData else { return }

        isLoading = true
        do {
            let request = ContactUsRequest(
                first_name: user.first_name ?? "",
                last_name: user.last_name ?? "",
                subject: selectedSubject,
                phone: user.phoneNumber ?? "",
                user: user.id ?? 0,
                address: user.address ?? "",
                email: user.email ?? "",
                message: commentText
            )

            let response = try await contactUsClient.postContactUsApi(request)
            alertMessage = response.mE_text_res
            showAlert = true
            commentText = ""
            selectedSubject = ""

        } catch {
            alertMessage = "Something went wrong. Please try again."
            showAlert = true
        }
        isLoading = false
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
  


    }
}


#Preview {
    ContactUsView()
}

