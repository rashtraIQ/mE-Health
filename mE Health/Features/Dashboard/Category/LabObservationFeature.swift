//
//  LabObservationFeature.swift
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
//# ============================================================================= on 23/05/25.
//


import ComposableArchitecture
import Foundation

struct LabObservationFeature: Reducer {
    
    struct State: Equatable {
        var labModel: ObservationModel?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadLabObservation
        case getLabObservationResponse(Result<ObservationModel, FHIRAPIError>)

    }

    @Dependency(\.fhirClient) var fhirClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadLabObservation:
            
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getLabObservations()
                    await send(.getLabObservationResponse(.success(conditionModel)))

                } catch {
                    await send(.getLabObservationResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getLabObservationResponse(.success(condition)):
            state.labModel = condition
            state.isLoading = false
            return .none

        case let .getLabObservationResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        }
    }
}


struct VitalsObservationFeature: Reducer {
    struct State: Equatable {
        var vitalModel: ObservationModel?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadVitalbservation
        case getVitalObservationResponse(Result<ObservationModel, FHIRAPIError>)

    }

    @Dependency(\.fhirClient) var fhirClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadVitalbservation:
            
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getVitalObservations()
                    await send(.getVitalObservationResponse(.success(conditionModel)))

                } catch {
                    await send(.getVitalObservationResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getVitalObservationResponse(.success(condition)):
            state.vitalModel = condition
            state.isLoading = false
            return .none

        case let .getVitalObservationResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        }
    }
}
