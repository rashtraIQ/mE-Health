
enum DashboardTab: Equatable {
    case menu
    case voice
    case dashboard
}

import SwiftUI

struct MainLayout<Content: View>: View {
    @Binding var selectedTab: DashboardTab
    @Binding var showMenu: Bool
    let selectedMenuTab: SideMenuTab
    let onMenuItemTap: (SideMenuTab) -> Void
    let content: Content
    let onDashboardTabTapped: (() -> Void)?

    init(
        selectedTab: Binding<DashboardTab>,
        showMenu: Binding<Bool>,
        selectedMenuTab: SideMenuTab,
        onMenuItemTap: @escaping (SideMenuTab) -> Void,
        onDashboardTabTapped: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self._showMenu = showMenu
        self.selectedMenuTab = selectedMenuTab
        self.onMenuItemTap = onMenuItemTap
        self.onDashboardTabTapped = onDashboardTabTapped
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            // Side menu
            SideMenuView(
                selectedTab: selectedMenuTab,
                onItemTap: { tab in
                    onMenuItemTap(tab)
                }
            )
            .frame(width: 116)
            .offset(x: showMenu ? 0 : -116)
            .animation(.easeInOut, value: showMenu)
            .zIndex(1)

            // Dimmed overlay
            if showMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showMenu = false }
                    .offset(x: 116)
                    .zIndex(1.1)
            }

            // Main content
            VStack(spacing: 0) {
                content
                Spacer().frame(height: 0)
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .offset(x: showMenu ? 110 : 0)
            .animation(.easeInOut, value: showMenu)
            .zIndex(2)

            // Tab bar (always pinned)
            VStack {
                Spacer()
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onMenuTapped: {
                        if selectedTab == .menu {
                            showMenu.toggle()
                        } else {
                            selectedTab = .menu
                        }
                    },
                    onDashboardTapped: {
                        selectedTab = .dashboard
                        showMenu = false
                        onDashboardTabTapped?()
                    }
                )
                .padding(.bottom, safeAreaBottomInset)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // <-- Only here
            .ignoresSafeArea(edges: .bottom)            // Keep touching device bottom
            .zIndex(50)
        }
        .onAppear {
            UIApplication.shared.keepTabBarFixed()
        }
    }
}


extension View {
    var safeAreaBottomInset: CGFloat {
        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    }
}
