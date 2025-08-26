//
//  CustomTabBar.swift
//  mE Health
//

import SwiftUI
import ComposableArchitecture

struct CustomTabBar: View {
    @Binding var selectedTab: DashboardTab
    var onMenuTapped: (() -> Void)? = nil
    var onDashboardTapped: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // Background shape with corner radius
            
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -2) // top shadow only
                .ignoresSafeArea(edges: .bottom)


            // Main tab items
            HStack {
                TabItem(
                    icon: "menu",
                    title: "Menu",
                    isSelected: selectedTab == .menu,
                    action: { selectedTab = .menu
                        onMenuTapped?()
                    }
                )

                Spacer()

                TabItem(
                    icon: "dashboard",
                    title: "Dashboard",
                    isSelected: selectedTab == .dashboard,
                    action: { selectedTab = .dashboard
                        onDashboardTapped?()
                    }
                )
            }
            .padding(.horizontal, 32)
            .padding(.top, 12) // adjust based on visual balance
            .padding(.bottom, 20) // so text/icons don’t touch bottom

            // Floating mic button
            Button(action: {
                selectedTab = .voice
            }) {
                ZStack {
//                    Circle()
//                        .fill(LinearGradient(colors: [Color(hex: "FB531C"), Color(hex: "F79E2D")],
//                                             startPoint: .topLeading,
//                                             endPoint: .bottomTrailing))
//                        .frame(width: 70, height: 70)
//                        .shadow(radius: 4)

                    Image("center_icon")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 4)
                }
            }
            .offset(y: -35)
        }
        .frame(height: 80)
    }
}
struct TabItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? Color(hex: "FB531C") : Color(hex: "333333"))
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color(hex: "FB531C") : Color(hex: "333333"))
            }
        }
    }
}
