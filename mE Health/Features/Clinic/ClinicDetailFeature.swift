//
//  ClinicDetailFeature.swift
//  mE Health
//

import ComposableArchitecture
import Foundation
import UIKit



struct ClinicDetailFeature: Reducer {
    struct State: Equatable {
        var isLoading: Bool = false
        var showErrorAlert = false
        var errorMessage = ""
        var isConnected: Bool = false
        var practicesData: [PracticesModelData]?
        var connectedPracticeIds: Set<Int> = []
        var recentPracticeIds: [Int] = [] // <-- Add this
    }

    enum Action: Equatable {
        case onDetailAppear(String)
        case authFailed(String)
        case getPracticesSuccessResponse(PracticesModel)
        case getPracticesFailureResponse(String)
        case connectTapped(PracticesModelData)
        case disconnectTapped(PracticesModelData)
        case connectionSucceeded(Int) // practice_id
        case disconnectionSucceeded(Int)
        case tokenValidationFailed(Int)


    }
    
    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.practicesClient) var practiceClient


    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .onDetailAppear(stateName):
                state.isLoading = true
                return .run { send in
                    do {
                        let practices = try await practiceClient.getPracticeList(stateName)
                        await send(.getPracticesSuccessResponse(practices))
                    } catch {
                        await send(.getPracticesFailureResponse(error.localizedDescription))
                    }
                }
                
            case .getPracticesFailureResponse(let message):
                state.isLoading = false
                state.errorMessage = message
                // Handle error
                return .none
                
            case let .getPracticesSuccessResponse(model):
                state.isLoading = false
                state.practicesData = model.data ?? []
                return .none

            case .connectTapped(let practice):
                guard let id = practice.id else { return .none }
                if !state.connectedPracticeIds.contains(id) {
                    if !state.recentPracticeIds.contains(id) {
                        state.recentPracticeIds.append(id)
                    }
                }

                return .run { send in
                    do {
                        let token = try await AuthService.shared.getValidAccessToken()
                        _ = TokenManager.saveAccessToken(token)
                        await send(.connectionSucceeded(practice.id ?? 0))
                    } catch {
                        await send(.tokenValidationFailed(practice.id ?? 0))
                    }
                }


            case let .tokenValidationFailed(id):
                print("❌ Token refresh failed")
                return .run { send in
                      do {
                          try await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
                          await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                          let callbackURL = try await AuthService.shared.startOAuthFlow()
                          guard let code = await AuthService.shared.extractCode(from: callbackURL) else {
                              await send(.authFailed("Failed to extract code"))
                              return
                          }
                          let (accessToken, patientID, expiresIn) = try await AuthService.shared.exchangeCodeForToken(code: code)
                          MEUtility.setME_PATIENTID(value: patientID)
                          print(accessToken)
                          print(patientID)
                          await AuthService.saveExpiryTimestamp(expiresIn)
                          _ = TokenManager.saveAccessToken(accessToken)
                          await send(.connectionSucceeded(id))
                      } catch {
                          await send(.authFailed(error.localizedDescription))
                      }
                  }
                
            case .authFailed(let error):
                state.showErrorAlert = true
                state.isLoading = false
                state.isConnected = false
                state.errorMessage = error
                return .none
                
            case .connectionSucceeded(let id):
                state.connectedPracticeIds.insert(id)
                return .none

            case .disconnectTapped(let practice):
                guard let practiceId = practice.id else {
                     return .none
                 }
                 state.connectedPracticeIds.remove(practiceId)
                 state.isLoading = false
                 state.isConnected = false

                 // Call logout and remove token
                 return .run { send in
                     do {
                         await AuthService.shared.logout() // Logout from FHIR
                         TokenManager.deleteAccessToken()       // Clear token
                     } catch {
                         print("Failed to logout from FHIR: \(error)")
                     }
                 }

            case .disconnectionSucceeded(_):
                return .none
            }
        }
    }
}


