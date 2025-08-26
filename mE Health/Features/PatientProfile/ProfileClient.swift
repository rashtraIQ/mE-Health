//
//  ProfileClient.swift
//  mE Health
//
//  Created by Rashida on 19/06/25.
//


import Foundation
import ComposableArchitecture

struct ProfileRequest: Encodable {
    let user_id: Int
}

protocol ProfileClient {
    func getUserProfileApi(_ request: ProfileRequest) async throws -> PatientProfilResponse
}

struct ApiProfileClient: ProfileClient {
    

    func getUserProfileApi(_ request: ProfileRequest) async throws -> PatientProfilResponse {
        var urlRequest = URLRequest(url: URL(string: Constants.API.getProfileApi)!)
        
        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }

        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(PatientProfilResponse.self, from: data)
    }
}

struct ProfileClientDependency {
    var getUserProfileApi: (_ request: ProfileRequest) async throws -> PatientProfilResponse
}

enum ProfileClientKey: DependencyKey {
    static let liveValue: ProfileClientDependency = ProfileClientDependency(
        getUserProfileApi : { request in
            try await ApiProfileClient().getUserProfileApi(request)
        }
    )
}

extension DependencyValues {
    var profileClient: ProfileClientDependency {
        get { self[ProfileClientKey.self] }
        set { self[ProfileClientKey.self] = newValue }
    }
}
