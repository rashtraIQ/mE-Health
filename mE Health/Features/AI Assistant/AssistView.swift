//
//  AssistView.swift
//  mE Health
//
//  Created by Rashida on 25/06/25.
//

import SwiftUI
import ComposableArchitecture

var txtCondition = ""

//struct AssistView: View {
//
//    @Environment(\.presentationMode) var presentationMode
//    @State private var navigateToDetail = false
//
////    let assistItem = [
////        AssistData(name: "Chronic Condition Detector"),
////        AssistData(name: "Preventive Care Advisor"),
////        AssistData(name: "Medication Adherence Risk Predictor"),
////        AssistData(name: "Social Determinants of Health (SDoH) Estimator"),
////        AssistData(name: "Social Determinants of Health (SDoH) Estimator"),
////        AssistData(name: "Social Determinants of Health (SDoH) Estimator"),
////        AssistData(name: "Polypharmacy Risk Detector"),
////        AssistData(name: "Gaps in Care Identifier"),
////        AssistData(name: "Behavioral Health Risk Estimator")]
//
//
//    let assistItem = [
//        AssistData(name: "Behavioral Health Risk Estimator"),
//        AssistData(name: "Chronic Condition Detector"),
//        AssistData(name: "Gaps in Care Identifier"),
//        AssistData(name: "Medication Adherence Risk Predictor"),
//        AssistData(name: "Polypharmacy Risk Detector"),
//        AssistData(name: "Preventive Care Advisor"),
//        AssistData(name: "Social Determinants of Health (SDoH) Estimator")]
//
//
//    @State private var selectedTab: DashboardTab = .dashboard
//    @State private var showMenu: Bool = false
//    @State private var selectedMenuTab: SideMenuTab = .dashboard
//    @State private var navigateToSettings = false
//    @State private var navigateToDashboard = false
//    @State private var navigateToPersona = false
//
//
//    var body: some View {
//        ZStack {
//
//            Color(hex: "F5F5FC")
//                .ignoresSafeArea()
//
//            MainLayout(
//                selectedTab: $selectedTab,
//                showMenu: $showMenu,
//                selectedMenuTab: selectedMenuTab,
//                onMenuItemTap: { tab in
//                    selectedMenuTab = tab
//                    showMenu = false
//
//                    // Optional: route or update state
//                    if tab == .dashboard {
//                        navigateToDashboard = true
//
//                    }
//                    else if tab == .settings {
//                        navigateToSettings = true
//                    }
//
//                    else if tab == .persona {
//                        navigateToPersona = true
//                    }
//                },
//                onDashboardTabTapped: {
//                        navigateToDashboard = true
//                    }
//            )
//            {
//
//                VStack(alignment: .leading, spacing: 16) {
//
//                    HStack {
//                        CustomBackButton {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//
//                    Text("Health")
//                       .font(.montserrat(34, weight: .bold))
//                        .padding(.horizontal)
//                        .padding(.top, 16)
//
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(spacing: 24) {
//                            ForEach(assistItem) { item in
//
//                                AssistCardView(assist: item) {
//                                    withAnimation {
//                                        txtCondition = item.name
//                                        navigateToDetail = true
//                                    }
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.top)
//                    NavigationLink(
//                        destination: AssistDetailView()
//                        ,
//                        isActive: $navigateToDetail
//                    ) {
//                        EmptyView()
//                    }
//
//                    navigationLinks()
//
//                }
//                .background(Color(hex: "F5F5FC").ignoresSafeArea())
//                .navigationBarBackButtonHidden(true)
//            }
//        }
//
//    }
//
//    @ViewBuilder
//    func navigationLinks() -> some View {
//
//        // ✅ Add this
//              NavigationLink(
//                  destination: SettingView(),
//                  isActive: $navigateToSettings
//              ) {
//                  EmptyView()
//              }
//
//        NavigationLink(
//            destination: DashboardView(
//                store: Store(
//                    initialState: DashboardFeature.State(),
//                    reducer: { DashboardFeature() }
//                )
//            ),
//            isActive: $navigateToDashboard
//        ) {
//            EmptyView()
//        }
//
//        NavigationLink(
//            destination: PersonaView(
//                store: Store(
//                    initialState: PersonaFeature.State(),
//                    reducer: { PersonaFeature() }
//                )
//            ),
//            isActive: $navigateToPersona
//        ) {
//            EmptyView()
//        }
//
//    }
//}
//
//
//#Preview {
//    AssistView()
//}

// Comment Assit api
import SwiftUI
import ComposableArchitecture

struct AssistView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToDetail = false
    @State private var navigateToHealth = false
    @Dependency(\.assitAdviceClient) var client
    
    @State private var assistItems: [AssistData] = []
    @State private var isLoading = false
    @State private var errorMessage: String?


    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Health")
                   .font(.montserrat(34, weight: .bold))
                    .padding(.horizontal)

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(assistItems) { item in
                                AssistCardView(assist: item) {
                                    withAnimation {
                                       
                                        txtCondition = item.item!
                                        print(txtCondition)
                                        if item.item! == "Health Goal Interpreter"{
                                            txtAddGoal = ""
                                            navigateToHealth = true
                                        }
                                        else if item.item! == "Behavioral Health Risk Estimator" || item.item! == "Chronic Condition Detector" || item.item! == "Gaps in Care Identifier" || item.item! == "Medication Adherence Risk Predictor" || item.item! == "Polypharmacy Risk Detector" {
                                          
                                            navigateToDetail = true
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top,1)
                    }
                    .padding(.top)
                }
                NavigationLink(
                    destination: AssistDetailView(),
                    isActive: $navigateToDetail
                ) {
                    EmptyView()
                }
                NavigationLink(
                    destination: HealthGoalView(),
                    isActive: $navigateToHealth
                ) {
                    EmptyView()
                }
            }
            .background(Color(hex: "F5F5FC").ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .task {
            await loadAssistItems()
        }
    }

    private func loadAssistItems() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await client.getAssistList(
                AssistRequest(application: "Health") // or dynamic
            )
            assistItems = response.data ?? []
//            for i in assistItems.count {
//                        Text("i is \(i)")
//                    }
            ForEach(assistItems) { item in
                //print(item.category)
            }
        } catch {
            errorMessage = "Failed to load assist items."
            print("API error:", error)
        }
    }


}


#Preview {
    AssistView()
}
