//
//  AIAssistantView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import SwiftUI
import SwiftUICore
import ComposableArchitecture

struct AIAssistantView: View {
    
    @State private var isAdviceViewActive = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAssistViewActive = false
    
    @State private var selectedTab: DashboardTab = .dashboard
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false

    
    var body: some View {
       
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
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
                            
                            else if tab == .persona {
                                navigateToPersona = true
                            }
                        },
                        onDashboardTabTapped: {
                                navigateToDashboard = true
                            }
                    ) {
                        
                        // MARK: Main Content (Sliding)
                        VStack(spacing: 0) {
                            
                            HStack {
                                CustomBackButton {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)

                            
                            Spacer()
                            
                            VStack(spacing: 24) {
                                
                                AIAssitCardButton(
                                    title: "Assist",
                                    iconName: "AI",
                                    gradientColors: [Color(hex: "FB531C"), Color(hex: "F79E2D")],
                                    onCardTap: {
                                        isAssistViewActive = true
                                    },
                                   
                                )
                                
                                AIAssitCardButton(
                                    title: "Advice",
                                    iconName: "shopping_cart",
                                    gradientColors: [Color(hex: "FB531C"), Color(hex: "F79E2D")],
                                    onCardTap: {
                                        isAdviceViewActive = true
                                    },
                                    
                                )
                                
                                
                                NavigationLink(
                                    destination: AdviceView()
                                    ,
                                    isActive: $isAdviceViewActive
                                ) {
                                    EmptyView()
                                }
                                
                                NavigationLink(
                                    destination: AssistView()
                                    ,
                                    isActive: $isAssistViewActive
                                ) {
                                    EmptyView()
                                }
                                
                                navigationLinks()
                            }
                           
                            
                            Spacer()
                            
                            // Reserve space for tab bar
                            Spacer().frame(height: 60)
                        }
                        .padding(.horizontal)
                        .background(Color.white.ignoresSafeArea())
                        .zIndex(2)
                    }
                    .onAppear {
                        //viewStore.send(.onAppear)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                
            }
        }
        
        
    }
    
    @ViewBuilder
    func navigationLinks() -> some View {
        
        // ✅ Add this
              NavigationLink(
                  destination: SettingView(),
                  isActive: $navigateToSettings
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

    }

}

#Preview {
    AIAssistantView()
    }
    
