//
//  ClinicListView.swift
//  mE Health
//

import SwiftUI
import ComposableArchitecture


// MARK: - Clinic Card View
struct ClinicCard: View {
    let state: TopStates

    var body: some View {
        VStack {
            Spacer()

            if let logoURL = state.logo, let url = URL(string: logoURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image("country_placeholder")
                        .resizable()
                }
                .scaledToFit()
                .frame(width: 40, height: 40)
            } else {
                Image("country_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }

            Text(state.state ?? "Unknown")
                .foregroundColor(.black)
                .font(.montserrat(10, weight: .bold))
                .padding(.top, 8)

            Text("\(state.count ?? 0)")
                .foregroundColor(Color(hex: "FB531C"))
                .font(.montserrat(13, weight: .bold))
                .padding(.top, 8)

            Spacer()
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(4)
    }
}

// MARK: - Clinic List View
struct ClinicListView: View {
    
    
    
    @State private var isLoading = false
    @State private var stateData: [TopStates]? = nil
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false

    @State private var searchText = ""
    @State private var selectedClinic: TopStates?
    @Environment(\.presentationMode) var presentationMode
    // 2-column grid layout
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    
    let practiceClient = PracticesClientKey.liveValue
    let localStorage = LocalClinicStorageKey.liveValue

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
                    else if tab == .settings {
                        navigateToSettings = true
                    }
                    
                    else if tab == .persona {
                        navigateToPersona = true
                    }
                }
                ,
                onDashboardTabTapped: {
                        navigateToDashboard = true
                    }
            ) {
                NavigationStack {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack {
                            CustomBackButton {
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        
                        Text("Connect to Your Provider")
                           .font(.montserrat(34, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top,16)
                        
                        // Search Bar
                        CustomSearchBar(text: $searchText)
                        
                        // Loading View
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        }
                        
                        // Grid List
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(filteredClinics(from: stateData), id: \.state) { clinic in
                                    ClinicCard(state: clinic)
                                        .onTapGesture {
                                            selectedClinic = clinic
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 8)
                        
                        NavigationLink(
                            destination: selectedClinic.map {
                                ClinicDetailListView(
                                    store: Store(
                                        initialState: ClinicDetailFeature.State(),
                                        reducer: {
                                            ClinicDetailFeature()
                                        }
                                    ), title: $0.state ?? ""
                                )
                            },
                            isActive: Binding(
                                get: { selectedClinic != nil },
                                set: { if !$0 { selectedClinic = nil } }
                            )
                        ) {
                            EmptyView()
                        }
                        
                        navigationLinks()
                    }
                    .padding(.top)
                    .onAppear(perform: loadClinicData)
                    .alert("Error", isPresented: .constant(showErrorAlert)) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(errorMessage)
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
            }
        
    }
    
    private func loadClinicData() {
        guard !isLoading else { return }

        isLoading = true
        Task {
            do {
                let result = try await practiceClient.getStateList()
                let topStates = result.data?.top_states ?? []
                stateData = topStates
                try await localStorage.saveStates(topStates)
            } catch {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
            isLoading = false
        }
    }


    func filteredClinics(from clinics: [TopStates]?) -> [TopStates] {
        guard let clinics = clinics else { return [] }

        if searchText.isEmpty {
            return clinics
        } else {
            return clinics.filter {
                ($0.state ?? "").localizedCaseInsensitiveContains(searchText)
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
