//
//  PersonaView.swift
//  mE Health
//

import SwiftUI
import ComposableArchitecture


struct PersonaView: View {
    let store: StoreOf<PersonaFeature>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .persona
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToContact = false
    
    

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
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
                               
                           },
                           onDashboardTabTapped: {
                                   navigateToDashboard = true
                               }
            ){
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        CustomBackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Text("My Persona")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewStore.items) { item in
                                Button(action: {
                                    viewStore.send(.itemTapped(item.destination))
                                }) {
                                    PersonaCardView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top)
                    }
                    navigationLinks(viewStore: viewStore)
                }
                .background(Color.white)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    @ViewBuilder
    func navigationLinks(viewStore: ViewStore<PersonaFeature.State, PersonaFeature.Action>) -> some View {
        NavigationLink(
            destination: PatientProfileView(
                store: Store(
                                            initialState: PatientProfileFeature.State(),
                                            reducer: { PatientProfileFeature() }
                                        )
            ),
            isActive: Binding(
                get: { viewStore.selectedDestination == .patientProfile },
                set: { if !$0 { viewStore.send(.dismissDestination) } }
            )
        ) {
            EmptyView()
        }

        NavigationLink(
            destination: MyHealthView(
                store: Store(
                    initialState: MyHealthFeature.State(),
                    reducer: { MyHealthFeature() }
                )

            ),
            isActive: Binding(
                get: { viewStore.selectedDestination == .myHealth },
                set: { if !$0 { viewStore.send(.dismissDestination) } }
            )
        ) {
            EmptyView()
        }
        
        // ✅ Add this
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





// MARK: - Preview

#Preview {
    PersonaView(
        store: Store(
            initialState: PersonaFeature.State(),
            reducer: {
                PersonaFeature()
            }
        )
    )
}

struct PersonaCardView: View {
    let item: PersonaItem

    var body: some View {
        HStack(spacing: 12) {
            // Leading gradient bar
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: Constants.API.PrimaryColorHex)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 12)
            .cornerRadius(5)

            Image(item.iconName)
                .foregroundColor(.orange)
                .font(.system(size: 22))

            Text(item.title)
                .foregroundColor(Color(hex: "777777"))
               .font(.montserrat(17, weight: .medium))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 12)
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
