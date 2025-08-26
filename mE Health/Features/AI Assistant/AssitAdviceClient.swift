
import Foundation
import ComposableArchitecture

struct AssistRequest: Encodable {
    let application: String
}

protocol AssitAdviceClient {
    func getAssistList(_ request: AssistRequest) async throws -> AssistResponse
    func callMeinsteinAPI(listNames: String) async throws -> ChatResponse
}

struct ApiAssitAdviceClient: AssitAdviceClient {
    
    func getAssistList(_ request: AssistRequest) async throws -> AssistResponse {
        guard var components = URLComponents(string: Constants.API.assistGetApi) else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "application", value: request.application)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        
        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }
        let parameterDictionary = ["application" : "Health"]
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
        urlRequest.httpBody = httpBody


        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(AssistResponse.self, from: data)
    }
    
    
    func callMeinsteinAPI(listNames: String) async throws -> ChatResponse {
        guard let url = URL(string: Constants.API.chatApi) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }
        print(request)
        print("Token \(token)")

        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        let body = RequestBody(
            messages: [Message(role: "user", content: listNames)],
            temperature: 0.7
        )
        print(body)
        

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ChatResponse.self, from: data)
    }

}

struct AssitAdviceClientDependency {
    var getAssistList: (_ request: AssistRequest) async throws -> AssistResponse
    var callMeinsteinAPI: (_ listNames: String) async throws -> ChatResponse

}

enum AssitAdviceClientKey: DependencyKey {
    static let liveValue: AssitAdviceClientDependency = AssitAdviceClientDependency(
        getAssistList : { request in
            try await ApiAssitAdviceClient().getAssistList(request)
        },
        callMeinsteinAPI: { listNames in
            try await ApiAssitAdviceClient().callMeinsteinAPI(listNames: listNames)
        }
    )
}

extension DependencyValues {
    var assitAdviceClient: AssitAdviceClientDependency {
        get { self[AssitAdviceClientKey.self] }
        set { self[AssitAdviceClientKey.self] = newValue }
    }
}
