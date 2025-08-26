//
//  ClinicDetailListView.swift
//  mE Health
//
import SwiftUI
import ComposableArchitecture

struct ClinicDetailListView: View {
    
    let store: StoreOf<ClinicDetailFeature>
    let title: String
    @State private var selectedTab = 0
    @State private var searchText = ""
    
    let tabs = ["All", "Recent", "Connected"]
    @State private var selectedIndex = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedBottomTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false

    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            
            MainLayout(
                selectedTab: $selectedBottomTab,
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
            )
            {
                NavigationStack{
                    VStack(spacing: 12) {
                        
                        HStack {
                            CustomBackButton {
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Title
                        Text(title)
                           .font(.montserrat(34, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top,16)
                        
                        // Segmented Control
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: Constants.API.PrimaryColorHex), lineWidth: 2)
                                .frame(height: 45)
                            
                            // Orange background that slides behind selected tab
                            GeometryReader { geo in
                                let tabWidth = geo.size.width / CGFloat(tabs.count)
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: Constants.API.PrimaryColorHex))
                                    .frame(width: tabWidth - 4, height: 41)
                                    .offset(x: CGFloat(selectedTab) * tabWidth + 2, y: 2)
                                    .animation(.easeInOut(duration: 0.25), value: selectedTab)
                            }
                            .frame(height: 45)
                            
                            // Tab Buttons
                            HStack(spacing: 0) {
                                ForEach(tabs.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedTab = index
                                    }) {
                                        Text(tabs[index])
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(selectedTab == index ? .white : .black)
                                             .font(.montserrat(16, weight: .semibold))
                                    }
                                }
                            }
                        }
                        .frame(height: 45)
                        .padding(.horizontal)
                        
                        let filteredBySearch = (viewStore.practicesData ?? []).filter {
                            searchText.isEmpty || ($0.practice_name?.localizedCaseInsensitiveContains(searchText) ?? false)
                        }
                        
                        
                        let filteredPractices: [PracticesModelData] = {
                            switch selectedTab {
                            case 0: return filteredBySearch
                            case 1:  // Add recent logic if needed
                                return filteredBySearch.filter { item in
                                    guard let id = item.id else { return false }
                                    return viewStore.recentPracticeIds.contains(id) &&
                                    !viewStore.connectedPracticeIds.contains(id)
                                }
                                
                            case 2: return filteredBySearch.filter { item in
                                viewStore.connectedPracticeIds.contains(item.id ?? 0)
                            }
                            default: return filteredBySearch
                            }
                        }()
                        
                        
                        // Search Bar
                        CustomSearchBar(text: $searchText)
                        
                        List(filteredPractices, id: \.practice_name) { item in
                            ClinicDetailCard(
                                practiceObj: item,
                                onConnect: {
                                    if viewStore.connectedPracticeIds.contains(item.id ?? 0) {
                                        viewStore.send(.disconnectTapped(item))
                                    } else {
                                        viewStore.send(.connectTapped(item))
                                    }
                                    
                                },
                                isConnected: viewStore.connectedPracticeIds.contains(item.id ?? 0)
                                
                            )
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 4)
                        }
                        .listStyle(PlainListStyle())
                        
                        navigationLinks()
                    }
                    .onAppear {
                        viewStore.send(.onDetailAppear(title))
                    }
                }
                .navigationBarBackButtonHidden(true)
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

// MARK: - List Item Card
struct ClinicDetailCard: View {
    let practiceObj: PracticesModelData
    var onConnect: () -> Void
    var isConnected: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card content
            HStack(alignment: .top, spacing: 12) {
                // Clinic image
                if let logoURL = practiceObj.logo_url, let url = URL(string: logoURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Image("Cambridge")
                            .resizable()
                    }
                    .scaledToFit()
                    .frame(width: 110, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.leading, 8)
                } else {
                    Image("Cambridge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(practiceObj.practice_name ?? "Cleveland Clinic London")
                        .font(.montserrat(20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack() {
                        
                        Button(action: {
                            onConnect()
                        }) {
                            Text(isConnected ? "Disconnect" : "Connect")
                                .font(.montserrat(10, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color(hex: Constants.API.PrimaryColorHex))
                                .cornerRadius(8)
                        }
                        if isConnected {
                            Image("refresh")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .padding(.leading, 4)
                        }
                    }
                }

                Spacer()
            }
            .padding(12)
            .frame(height: 132)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)

            // ✅ Badge overlay, inset from top and trailing
            Text("MyChart")
                .font(.montserrat(10, weight: .semibold))
                .frame(height: 28)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    RoundedCorners(color: .black,
                                   tl: 0, tr: 12, bl: 12, br: 0)
                )
                .padding(.top, 0)
                .padding(.trailing, 0) // 👈 Matches card's internal padding
        }
        .padding(.horizontal)
    }
}


#Preview {
    ClinicDetailListView(
        store: Store(
            initialState: ClinicDetailFeature.State(),
            reducer: {
                ClinicDetailFeature()
            }
        ), title: ""
    )
}
