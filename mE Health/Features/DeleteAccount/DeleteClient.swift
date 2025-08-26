
import Foundation
import ComposableArchitecture

struct DeleteRequest: Encodable {
    let reason: Int
    let source: String
    let satisfaction_rating: Int
    let additional_feedback: String
    let current_password: String
}


protocol DeleteClient {
    func getReasonList() async throws -> deleteReasonResponse
    func postDeleteApi(_ request: DeleteRequest) async throws -> deleteReasonResponse
}

struct DeleteClientDependency {
    var getReasonList: () async throws -> deleteReasonResponse
    var postDeleteApi: (_ request: DeleteRequest) async throws -> deleteReasonResponse
}


struct ApiDeleteClient: DeleteClient {
    func getReasonList() async throws -> deleteReasonResponse {

        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }
        var request = URLRequest(url: URL(string: Constants.API.deleteReasonApi)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(deleteReasonResponse.self, from: data)
    }
    
    func postDeleteApi(_ request: DeleteRequest) async throws -> deleteReasonResponse {
        
        var urlRequest = URLRequest(url: URL(string: Constants.API.deleteApi)!)
        
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

        return try JSONDecoder().decode(deleteReasonResponse.self, from: data)

        
    }
}

enum DeleteClientKey: DependencyKey {
    static let liveValue: DeleteClientDependency = DeleteClientDependency(
        getReasonList: {
            try await ApiDeleteClient().getReasonList()
        },
        postDeleteApi : { request in
            try await ApiDeleteClient().postDeleteApi(request)
        }
    )
}

extension DependencyValues {
    var deleteClient: DeleteClientDependency {
        get { self[DeleteClientKey.self] }
        set { self[DeleteClientKey.self] = newValue }
    }
}
