//
//  PatientProfileView.swift
//  mE Health
//
//  Created by Ishant on 13/06/25.
//

import SwiftUI
import ComposableArchitecture



struct PatientProfileView: View {
    let store: StoreOf<PatientProfileFeature>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .persona
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToContact = false

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            
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
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        CustomBackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Text("My Profile")
                        .font(.montserrat(37, weight: .bold))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    let firstname = userProfileData?.first_name ?? ""
                    let last_name = userProfileData?.last_name ?? ""
                    
                    let address = userProfileData?.address ?? ""
                    let countryCode = userProfileData?.countryCode ?? ""
                    let phoneNumber = userProfileData?.phoneNumber ?? ""
                    let number = "\(countryCode) \(phoneNumber)"
                    
                    let email = userProfileData?.email ?? ""
                    let gender = userProfileData?.gender ?? ""
                    let dateOfBirth = userProfileData?.dateOfBirth ?? ""
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        // Header Card
                        VStack(alignment: .leading,spacing: 24) {
                            HStack(spacing: 8) {
                                VStack(alignment: .leading,spacing: 12) {
                                    Text("\(firstname) \(last_name)")
                                        .font(.montserrat(24, weight: .bold))
                                        .foregroundColor(Color(hex: "FF6605"))
                                    Text(address)
                                         .font(.montserrat(14, weight: .regular))
                                        .foregroundColor(Color(hex: "333333"))
                                    ProgressView(value: 0.01)
                                        .accentColor(.green)
                                        .padding([.top,.bottom],4)
                                    
                                }
                                .padding(.leading,8)
                                Spacer()
                                Image("profile_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 74, height: 74)
                                    .clipShape(Circle())
                                    .padding(.trailing, 8)
                                    
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        .frame(height:150)
                        
                        Spacer()
                        
                        VStack(alignment: .leading,spacing: 8) {
                            
                            Text("Basic Details")
                                .font(.montserrat(18, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading,16)
                                .padding(.top,16)
                            
                           
                                VStack(spacing: 24) {
                                    ProfileCardView(icon: "Phone", title: "Phone", value: number)
                                    ProfileCardView(icon: "mail", title: "Email", value: email)
                                    ProfileCardView(icon: "address", title: "Address (1)", value: address)
                                    ProfileCardView(icon: "anniversary", title: "Anniversary", value: "")
                                    
                                    MarriedCardView(icon: "married", title: "Married", isOn: viewStore.binding(
                                        get: \.isMarried,
                                        send: PatientProfileFeature.Action.toggleMarried
                                    ))
                                    
                                    ProfileCardView(icon: "gender", title: "Gender", value: gender)
                                    ProfileCardView(icon: "dob", title: "Date Of Birth", value: dateOfBirth)
                                }
                                .padding()
                               
                            
                        }
                        
                    }
                    .padding(.bottom, 100)
                    navigationLinks()
                    
                }
                .onAppear {
                    print("👀 PatientProfileView appeared")
                    
                }
                .onDisappear {
                    print("👋 PatientProfileView disappeared")
                }
                
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        
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

    }
    
}


struct ProfileCardView: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        Group {
            if value.isEmpty {
                HStack(spacing: 12) {
                    Image(icon)
                        .font(.title3)
                        .foregroundColor(.orange)

                    Text(title)
                       .font(.montserrat(17, weight: .medium))
                        .foregroundColor(.gray)

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            } else {
                HStack(alignment: .top, spacing: 12) {
                    Image(icon)
                        .font(.title3)
                        .foregroundColor(.orange)
                        .padding(.top, 4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                           .font(.montserrat(17, weight: .medium))
                            .foregroundColor(.gray)


                        Text(value)
                            .font(.montserrat(17, weight: .semibold))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

struct MarriedCardView: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .font(.title3)
                .foregroundColor(.orange)

            Text(title)
               .font(.montserrat(17, weight: .medium))
                .foregroundColor(.gray)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}



#Preview {
    PatientProfileView(
        store: Store(
            initialState: PatientProfileFeature.State(),
            reducer: {
                PatientProfileFeature()
            }
        )
    )
}
