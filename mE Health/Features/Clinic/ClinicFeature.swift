//
//  ClinicFeature.swift
//  mE Health
//

import ComposableArchitecture
import Foundation

struct ClinicFeature: Reducer {
    struct State: Equatable {
        var stateData: [TopStates]?
        var isLoading: Bool = false
        var showErrorAlert = false
        var errorMessage = ""
       
    }

    enum Action: Equatable {
        case onAppear
        case getStateSuccessResponse(StateModel)
        case getStateFailureResponse(String)
        case fetchDataOnList
        case fetchDataFromLocal([TopStates])
        case cancelFetch
    }
    
    @Dependency(\.practicesClient) var practiceClient
    @Dependency(\.localClinicStorage) var localStorage

    enum CancelID { static let fetchStates = "fetchStates" }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                state.isLoading = true

                return .run { send in
                    
                    do {
                        let states = try await practiceClient.getStateList()
                        await send(.getStateSuccessResponse(states))
                    } catch {
                        print(error.localizedDescription)
                        await send(.getStateFailureResponse(error.localizedDescription))
                    }
                    
//                    if let cached = try await localStorage.loadStates(), !cached.isEmpty {
//                        await send(.fetchDataFromLocal(cached))
//                    } else {
//                        do {
//                            let states = try await practiceClient.getStateList()
//                            await send(.getStateSuccessResponse(states))
//                        } catch {
//                            await send(.getStateFailureResponse(error.localizedDescription))
//                        }
//                    }
                }
                .cancellable(id: CancelID.fetchStates, cancelInFlight: true)
                
            case .cancelFetch:
                return .cancel(id: CancelID.fetchStates)



            case let .fetchDataFromLocal(cachedStates):
                state.stateData = cachedStates
                state.isLoading = false
                return .none

            case let .getStateSuccessResponse(model):
                let topStates = model.data?.top_states ?? []
                state.stateData = topStates
                state.isLoading = false
                return .run { _ in
                    try await localStorage.saveStates(topStates)
                }

            case .fetchDataOnList:
                state.isLoading = false
                return .none

            case .getStateFailureResponse(let message):
                state.isLoading = false
                state.errorMessage = message
                // Handle error
                return .none
                

            }
        }
    }
}
