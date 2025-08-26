//
//  mE_HealthApp.swift
//  mE Health
//
//  # =============================================================================
//# mEinstein - CONFIDENTIAL
//#
//# Copyright ©️ 2025 mEinstein Inc. All Rights Reserved.
//#
//# NOTICE: All information contained herein is and remains the property of
//# mEinstein Inc. The intellectual and technical concepts contained herein are
//# proprietary to mEinstein Inc. and may be covered by U.S. and foreign patents,
//# patents in process, and are protected by trade secret or copyright law.
//#
//# Dissemination of this information, or reproduction of this material,
//# is strictly forbidden unless prior written permission is obtained from
//# mEinstein Inc.
//#
//# Author(s): Ishant 
//# ============================================================================= on 6/05/25.
//

import UIKit
import SwiftUI
import ComposableArchitecture

@main
struct mE_HealthApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
            // appearance + attempt once at app start
            UITabBar.appearance().isTranslucent = true
            UIApplication.shared.keepTabBarFixed()
        }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashScreen(
                    store: Store(
                        initialState: AppFeature.State(),
                        reducer: {
                            AppFeature()
                        }
                    )
                )
                .onAppear {
                                    // call again once view appears (windows/scene are more likely ready)
                                    UIApplication.shared.keepTabBarFixed()
                                }
            }

        }
    }
}

extension UIApplication {
    func keepTabBarFixed() {
        // run async on main queue so windows are available even if called early
        DispatchQueue.main.async {
            for scene in self.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else { continue }
                for window in windowScene.windows {
                    if #available(iOS 15.0, *) {
                        window.keyboardLayoutGuide.followsUndockedKeyboard = false
                    }
                }
            }
        }
    }
}
