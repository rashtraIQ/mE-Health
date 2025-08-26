//
//  PractionerFeature.swift
//  mE Health
//
//  Created by //# Author(s): Ishant  on 12/06/25.
//

import ComposableArchitecture
import Foundation

struct PractionerFeature: Reducer {
    struct State: Equatable {
        var practionerModel: Practitioner?
        var practionerRoleModel: PractitionerRole?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadPractioner
        case getPractionerResponse(Result<Practitioner, FHIRAPIError>)
        case loadPractionerRole
        case getPractionerRoleResponse(Result<PractitionerRole, FHIRAPIError>)
        case noDataFound
        
    }

    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.coreDataClient) var coreDataClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadPractioner:
            
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getPractitioner()
                    await send(.getPractionerResponse(.success(conditionModel)))

                } catch {
                    await send(.getPractionerResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getPractionerResponse(.success(condition)):
            state.practionerModel = condition
            state.isLoading = false
//            do {
//                try coreDataClient.saveResourceTree(condition)
//            } catch {
//                print("❌ Failed to save MEdication to Core Data: \(error)")
//            }
            return .none

        case let .getPractionerResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        case .loadPractionerRole:
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    
                    if let practitionerId = MEUtility.getME_PRACTITIONERD() {
                        let conditionModel = try await fhirClient.getPractitionerRoles(practitionerId)
                        await send(.getPractionerRoleResponse(.success(conditionModel)))
                    }
                    await send(.noDataFound)

                } catch {
                    await send(.getPractionerRoleResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }
            
        case let .getPractionerRoleResponse(.success(condition)):
            state.practionerRoleModel = condition
            state.isLoading = false
//            do {
//                try coreDataClient.saveResourceTree(condition)
//            } catch {
//                print("❌ Failed to save MEdication to Core Data: \(error)")
//            }
            return .none

        case let .getPractionerRoleResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        case .noDataFound:
            state.isLoading = false
            state.errorMessage = "No Data found"
            return .none

        }
    }
}
