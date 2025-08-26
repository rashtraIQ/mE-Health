//
//  ContactClient.swift
//  mE Health
//
//  Created by Rashida on 4/08/25.
//


import Foundation
import ComposableArchitecture

struct ContactUsRequest: Codable {
    let first_name: String
    let last_name: String
    let subject: String
    let phone: String
    let user: Int
    let address: String
    let email: String
    let message: String
}

struct ContactUsResponse: Codable {
    let mE_text_res: String
    let status: Int
}


protocol ContactUsClient {
    func postContactUsApi(_ request: ContactUsRequest) async throws -> ContactUsResponse
}

struct ContactUsClientDependency {
    var postContactUsApi: (_ request: ContactUsRequest) async throws -> ContactUsResponse
}


struct ApiContactUsClient: ContactUsClient {

    
    func postContactUsApi(_ request: ContactUsRequest) async throws -> ContactUsResponse {
        
        var urlRequest = URLRequest(url: URL(string: Constants.API.contactUsApi)!)
        
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

        return try JSONDecoder().decode(ContactUsResponse.self, from: data)

        
    }
}

enum ContactUsClientKey: DependencyKey {
    static let liveValue: ContactUsClientDependency = ContactUsClientDependency(
        postContactUsApi : { request in
            try await ApiContactUsClient().postContactUsApi(request)
        }
    )
}

extension DependencyValues {
    var contactUsClient: ContactUsClientDependency {
        get { self[ContactUsClientKey.self] }
        set { self[ContactUsClientKey.self] = newValue }
    }
}
