//
//  SettingView.swift
//  mE Health
//
//  Created by Rashida on 4/07/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var locationAccess: LocationAccess = .whileUsing
    @State private var siriAccess: Bool = true
    @State private var whileUsing: Bool = true
    @State private var Always: Bool = true
    @State private var allowNever: Bool = true
    @State private var allowAlways: Bool = true
    @State private var allowMeAlways: Bool = true
    
    @State private var isClinicListActive = false
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var navigateToContact = false
    @State private var navigateToDelete = false

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
        ) {
            VStack(spacing: 8) {
                
                HStack {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Settings")
                            .font(.montserrat(37, weight: .bold))
                        
                        Group {
                            Text("Preferences")
                                 .font(.montserrat(16, weight: .semibold))
                            
                           
                            SettingRow(icon: "lockOrange", title: "Change Password") {
                                
                            }
                            SettingRow(icon: "Odometer", title: "Update Preferences") {
                                
                            }
                        }


                        Spacer(minLength: 8)
                        
                        Group {
                            Text("Connected Accounts")
                                 .font(.montserrat(16, weight: .semibold))
                            
                            SettingRow(icon: "Health", title: "Health Care ") {
                                isClinicListActive = true
                            }
                            
                            SettingRow(icon: "transaction", title: "Transactions") {
                               
                            }
                            
                            SettingRow(icon: "bank", title: "Bank Accounts") {
                               
                            }
                            
                        }
                        
                        Spacer(minLength: 8)
                        
                        Group {
                            Text("Allow Location Access")
                                 .font(.montserrat(16, weight: .semibold))
                            
                            ToggleRow(label: "Never", icon: "never", isOn: $allowNever)
                            
                            ToggleRow(label: "While Using The App", icon: "play", isOn: $allowAlways)
                            
                            ToggleRow(label: "Always", icon: "tick", isOn: $Always)
                            
                        }
                        
                        Spacer(minLength: 8)
                        
                        Group {
                            Text("Allow mE to Access")
                                 .font(.montserrat(16, weight: .semibold))
                            
                            ToggleRow(label: "Siri & Search", icon: "remix", isOn: $siriAccess)
                            
                            ToggleRow(label: "While Using The App", icon: "married", isOn: $whileUsing)
                            
                            ToggleRow(label: "Always", icon: "married", isOn: $allowMeAlways)
                        }
                        
                        Spacer(minLength: 8)
                        
                        Group {
                            Text("Delete Account")
                                 .font(.montserrat(16, weight: .semibold))
                            
                            SettingRow(icon: "Odometer", title: "Delete Account") {
                                navigateToDelete = true
                            }
                            
                            
                        }
                        
                        Spacer(minLength: 24)
                        
                        NavigationLink(
                            destination:  ClinicListView(),
                            isActive: $isClinicListActive
                        ) {
                            EmptyView()
                        }
                        
                        NavigationLink(
                            destination:  DeleteAccountView(),
                            isActive: $navigateToDelete
                        ) {
                            EmptyView()
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    navigationLinks()
                }
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)

        }
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
            destination: ContactUsView(),
            isActive: $navigateToContact
        ) {
            EmptyView()
        }


    }

    enum LocationAccess {
        case never, whileUsing, always
    }
}

// MARK: - Reusable Components

struct SettingRow: View {
    var icon: String
    var title: String
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack {
                Image(icon)
                    .foregroundColor(Color(hex: Constants.API.PrimaryColorHex))
                Text(title)
                    .font(.montserrat(16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle()) // So it looks like your custom row, not a blue button
    }

}



struct ToggleRow: View {
    var label: String
    var icon: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(icon)
                .foregroundColor(Color(hex: Constants.API.PrimaryColorHex))
            Text(label)
                .font(.montserrat(16, weight: .medium))
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(CustomToggleStyle())
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius:5)
    }
}




// MARK: - Preview

#Preview {
    SettingView()
}


struct CustomToggleStyle: ToggleStyle {
    var onColor: Color = Color(hex: "#FF6605")
    var offColor: Color = Color(hex: "#6E6B78")

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 40, height: 24)

                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}
//}
