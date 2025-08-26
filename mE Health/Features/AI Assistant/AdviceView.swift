

import SwiftUI
import ComposableArchitecture
import CoreData

var assitcontent = ""

// MARK: - Clinic List View
struct AdviceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showOverlay = false
    
    @State private var showFilterScreen = false
    @State private var selectedFilters: Set<FilterOption> = [.all]

    @State private var selectedTab: DashboardTab = .dashboard
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToSettings = false
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var isAssistViewActive = false
 
    @State private var allAdviceItems: [AdviceItemData] = []
    @State private var adviceList: [AdviceItemData] = []
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @State private var isFilterPopupShown = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack {
                            CustomBackButton {
                                presentationMode.wrappedValue.dismiss()
                            }
                            Spacer()
                            
                            Button(action: {
                                showFilterScreen = true
                                showFilterPopup()
                            }) {
                                Image("filter")
                                    .foregroundColor(Color(hex: "FF6605"))
                            }

                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        Text("Advice")
                           .font(.montserrat(34, weight: .bold))
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 24) {
                                if adviceList.isEmpty {
                                    NoDataAdviceView(
                                        onTap: {
                                            isAssistViewActive = true
                                    })
                                    .padding(.top, 44)
                                } else {
                                    ForEach($adviceList) { $item in
                                        AdviceCardView(
                                            advice: $item,
                                            onTap: {
                                                withAnimation {
                                                    showOverlay = true
                                                }
                                            },
                                            onUpdate: {
                                                loadAdvice()
                                            },
                                            onRemoveIfIgnored: {
                                                if let index = allAdviceItems.firstIndex(where: { $0.id == item.id }) {
                                                    allAdviceItems[index].ignore = "1"
                                                }

                                                if !selectedFilters.contains(.ignore) {
                                                    if let index = adviceList.firstIndex(where: { $0.id == item.id }) {
                                                        withAnimation {
                                                            adviceList.remove(at: index)
                                                        }
                                                    }
                                                } else {
                                                    applyFilter()
                                                }
                                            }

                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                        
                    }
                    .padding(.bottom, 100)
                    .navigationBarBackButtonHidden(true)

                    NavigationLink(
                        destination: AssistView()
                        ,
                        isActive: $isAssistViewActive
                    ) {
                        EmptyView()
                    }
                    navigationLinks()
                }
                // MARK: - Overlay
                GeometryReader { geo in
                    if showOverlay {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .transition(.opacity)

                            VStack(spacing: 0) {
                                ScrollView {
                                    Text(assitcontent)
                                        .font(.montserrat(14, weight: .semibold))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .padding(.top, 24)
                                }
                                .frame(maxHeight: geo.size.height * 0.5) // 50% of screen

                                Divider()

                                Button(action: {
                                    withAnimation {
                                        showOverlay = false
                                    }
                                }) {
                                    Text("OK")
                                        .font(.montserrat(20, weight: .bold))
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity)
                                        .padding(.bottom, 12)
                                        .padding(.top,12)
                                        
                                }
                            }
                            .padding(.top, 16)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.horizontal, 24)
                            .transition(.scale)
                        }
                        .zIndex(10)
                    }
                }

            }
        }.onAppear(){
            loadAdvice()
        }
    }
    
    func showFilterPopup() {
        if isFilterPopupShown { return }

        isFilterPopupShown = true
        
        viewControllerHolder?.present(
            style: .overCurrentContext,
            transitionStyle: .crossDissolve
        ) {
            AdviceFilterView(
                selectedFilters: $selectedFilters,
                dismiss: {
                    isFilterPopupShown = false
                    applyFilter()
                }
            )
        }

    }

    
    func loadAdvice() {
        let context = PersistenceController.shared.adviceContext
        let request: NSFetchRequest<Advicedata> = Advicedata.fetchRequest()
        
        do {
            let advicedataArray = try context.fetch(request).reversed()
           
            let allItems = advicedataArray.map { item in
                
                AdviceItemData(
                    
                    id: UUID(),
                    role: item.role ?? "",
                    content: item.content ?? "",
                    title: item.title ?? "",
                    date: item.date ?? "",
                    fav: item.fav ?? "",
                    ignore: item.ignore ?? "",
                    review: item.review ?? "",
                    read: item.read ?? "",
                    unread: item.unread ?? ""
                )
            }
            
            self.allAdviceItems = allItems.filter { $0.ignore != "1" }
            applyFilter()
        } catch {
            print("Failed to fetch: \(error)")
            self.adviceList = []
        }
    }

    func applyFilter() {
        guard !selectedFilters.contains(.all) else {
            adviceList = allAdviceItems
            return
        }

        // If .ignore is selected, load *all* items from Core Data
        if selectedFilters.contains(.ignore) {
            let context = PersistenceController.shared.adviceContext
            let request: NSFetchRequest<Advicedata> = Advicedata.fetchRequest()

            do {
                let advicedataArray = try context.fetch(request)
                let ignoredItems = advicedataArray.compactMap { item -> AdviceItemData? in
                    guard item.ignore == "1" else { return nil }

                    return AdviceItemData(
                        id: UUID(),
                        role: item.role ?? "",
                        content: item.content ?? "",
                        title: item.title ?? "",
                        date: item.date ?? "",
                        fav: item.fav ?? "",
                        ignore: item.ignore ?? "",
                        review: item.review ?? "",
                        read: item.read ?? "",
                        unread: item.unread ?? ""
                    )
                }

                adviceList = ignoredItems
                return
            } catch {
                print("Fetch for ignore filter failed: \(error)")
                adviceList = []
            }
        } else {
            // Normal filter on allAdviceItems
            adviceList = allAdviceItems.filter { item in
                var match = false
                for filter in selectedFilters {
                    switch filter {
                    case .fav:
                        match = match || item.fav == "1"
                    case .review:
                        match = match || item.review == "1"
                    case .read:
                        match = match || item.read == "1"
                    case .unread:
                        match = match || item.unread == "1"
                    default:
                        break
                    }
                }
                return match
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
    AdviceView()
}




