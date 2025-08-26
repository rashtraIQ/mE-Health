//
//  LoginClient.swift
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
//# ============================================================================= on 12/05/25.
//

import Foundation
import ComposableArchitecture

struct LoginRequest: Encodable {
    let email: String
    let password: String
    let firebase_token: String
    let user_type: String
}


protocol LoginClient {
    func login(_ request: LoginRequest) async throws -> LoginResponse
   
}

struct ApiLoginClient: LoginClient {
    func login(_ request: LoginRequest) async throws -> LoginResponse {
        var urlRequest = URLRequest(url: URL(string: Constants.API.loginApi)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }


    
}

struct LoginClientDependency {
    var login: (_ request: LoginRequest) async throws -> LoginResponse
   
}

enum LoginClientKey: DependencyKey {
    static let liveValue: LoginClientDependency = LoginClientDependency(
        login: { request in
            try await ApiLoginClient().login(request)
        }
    )
}

extension DependencyValues {
    var loginClient: LoginClientDependency {
        get { self[LoginClientKey.self] }
        set { self[LoginClientKey.self] = newValue }
    }
}


struct AppEnvironment {
    var loginClient: LoginClient
    var practicesClient:PracticesClient
    var profileClient:ProfileClient
    
}
