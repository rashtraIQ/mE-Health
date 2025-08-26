import Foundation
import AppAuth
import AuthenticationServices
import ComposableArchitecture
import Dependencies
import CryptoKit
import Combine

enum AuthError: Error, LocalizedError, Equatable {
    case authFailed
    case tokenExchangeFailed
    case unknown

    var errorDescription: String? {
        switch self {
        case .authFailed: return "Authentication failed"
        case .tokenExchangeFailed: return "Token exchange failed"
        case .unknown: return "Unknown error"
        }
    }
}

final class AuthService: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = AuthService()
    private var codeVerifier = ""
    
    // Token Info
    private(set) var accessToken: String?
    private(set) var patientID: String?
    private var expiryDate: Date?

    func getValidAccessToken() async throws -> String {
        if let token = TokenManager.fetchAccessToken(), AuthService.isTokenValid() {
            return token
        }

        // Token is expired or missing, trigger re-auth
        let callbackURL = try await startOAuthFlow()
        
        guard let code = extractCode(from: callbackURL) else {
            throw AuthError.authFailed
        }

        let (newToken, patientID, expiresIn) = try await exchangeCodeForToken(code: code)
        
        self.accessToken = newToken
        self.patientID = patientID
        self.expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn - 60))
        MEUtility.setME_PATIENTID(value: patientID)
        _ = TokenManager.saveAccessToken(newToken)
        AuthService.saveExpiryTimestamp(expiresIn)
        
        return newToken
    }

    
    static func saveExpiryTimestamp(_ expiresIn: Int) {
        let expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn - 60)) // 1-minute buffer
        UserDefaults.standard.set(expiryDate, forKey: "tokenExpiryDate")
    }
    
    static func clearExpiryTimestamp() {
        UserDefaults.standard.removeObject(forKey: "tokenExpiryDate")
    }


    static func isTokenValid() -> Bool {
        guard let expiryDate = UserDefaults.standard.object(forKey: "tokenExpiryDate") as? Date else {
            return false
        }
        return Date() < expiryDate
    }

    func logout() {
        TokenManager.deleteAccessToken()
        AuthService.clearExpiryTimestamp()
        MEUtility.setME_PATIENTID(value: "")
    }


    func startOAuthFlow() async throws -> URL {
        let (verifier, challenge) = self.generateCodeVerifierAndChallenge()
        self.codeVerifier = verifier
        let authURL = URL(string: "https://fhir.epic.com/interconnect-fhir-oauth/oauth2/authorize?client_id=\(Constants.API.clientID)&response_type=code&redirect_uri=\(Constants.API.redirectURI)&scope=openid profile patient/*.read patient/*.write offline_access&code_challenge=\(challenge)&code_challenge_method=S256")!
        

        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: Constants.API.callbackScheme) { callbackURL, error in
                if let url = callbackURL {
                    continuation.resume(returning: url)
                } else {
                    DispatchQueue.main.async {
                          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                      }
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }

    }

    func extractCode(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "code" })?.value
    }

    func exchangeCodeForToken(code: String) async throws -> (String, String, Int) {

        var request = URLRequest(url: URL(string: Constants.API.tokenEndpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.API.redirectURI,
            "client_id": Constants.API.clientID,
            "code_verifier": self.codeVerifier
        ]

       // request.httpBody = bodyParams.percentEncoded()

        request.httpBody = bodyParams
            .map { key, value in "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)


        let (data, _) = try await URLSession.shared.data(for: request)

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AuthError.tokenExchangeFailed
        }
        
        print(json)

        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let accessToken = json["access_token"] as? String,
            let patientID = json["patient"] as? String,
            let expiresIn = json["expires_in"] as? Int
        else {
            throw AuthError.tokenExchangeFailed
        }

        return (accessToken, patientID, expiresIn)
    }

    private var cancellables = Set<AnyCancellable>()

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }

    private func generateCodeVerifierAndChallenge() -> (String, String) {
        let verifier = randomString(length: 64)
        let data = verifier.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        let challenge = base64URLEncode(data: Data(hash))
        return (verifier, challenge)
    }

    private func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }

    private func base64URLEncode(data: Data) -> String {
        return data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}




extension Dictionary where Key == String, Value == String {
    func percentEncoded() -> Data? {
        let parameterArray = self.map { key, value in
            let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(escapedKey)=\(escapedValue)"
        }
        let joinedParams = parameterArray.joined(separator: "&")
        return joinedParams.data(using: .utf8)
    }
}

struct AuthServiceClient {
    var startOAuthFlow: @Sendable () async throws -> URL
    var exchangeCodeForToken: @Sendable (_ code: String) async throws -> (String, String, Int)
}

private enum AuthServiceKey: DependencyKey {
    static let liveValue: AuthServiceClient = AuthServiceClient(
        startOAuthFlow: {
            try await AuthService.shared.startOAuthFlow()
        },
        exchangeCodeForToken: { code in try await AuthService.shared.exchangeCodeForToken(code: code) }
    )
}

extension DependencyValues {
    var authService: AuthServiceClient {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}


struct TokenExchangeResult: Equatable {
    let accessToken: String
    let patientID: String
    let expiresIn:Int
}

