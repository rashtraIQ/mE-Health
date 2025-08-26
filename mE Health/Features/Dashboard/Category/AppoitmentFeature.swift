//
//  AppoitmentFeature.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 13/06/25.
//


import ComposableArchitecture
import Foundation

struct AppoitmentFeature: Reducer {
    struct State: Equatable {
        var appoitmentModel : AppoitmentResource?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadAppoinment
        case getAppoitmentResponse(Result<AppoitmentModel, FHIRAPIError>)
        case getDetailtResponse(Result<AppoitmentResource, FHIRAPIError>)
        
    }

    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.coreDataClient) var coreDataClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadAppoinment:
            
            state.isLoading = true
            state.errorMessage = ""
            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getAppoitment()
                    await send(.getAppoitmentResponse(.success(conditionModel)))
                } catch {
                    await send(.getAppoitmentResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getAppoitmentResponse(.success(model)):
            let resource = model.entry?.first?.resource
            let id = resource?.id ?? ""
            return .run { send in
                do {
                    let resourceModel = try await fhirClient.getAppoitmentDetail(id)
                    await send(.getDetailtResponse(.success(resourceModel)))
                } catch {
                    await send(.getDetailtResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getAppoitmentResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none
            
        case let .getDetailtResponse(.success(model)):
            state.isLoading = false
            state.errorMessage = nil
            state.appoitmentModel = model
            return .none

        case let .getDetailtResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        }
    }
}
