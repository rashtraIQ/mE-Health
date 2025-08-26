//
//  SessionManager.swift
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
//# ============================================================================= on 29/05/25.
//

import SwiftUI

class SessionManager {
    static let shared = SessionManager()

    private let userDefaults = UserDefaults.standard

    var isLoggedIn: Bool {
        userDefaults.bool(forKey: Constants.API.isLoggedIn)
    }

    func saveLoginSession() {
        userDefaults.set(true, forKey: Constants.API.isLoggedIn)
    }

    func clearSession() {
        userDefaults.removeObject(forKey: Constants.API.isLoggedIn)
    }
    
}
