//
//  MedicationFeature.swift
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
//# ============================================================================= on 22/05/25.
//

import ComposableArchitecture
import Foundation

struct MedicationFeature: Reducer {
    struct State: Equatable {
        var medicationModel: MedicationModel?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadMedication
        case getMedicationResponse(Result<MedicationModel, FHIRAPIError>)

    }

    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.coreDataClient) var coreDataClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadMedication:
            
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getMedicationRequests()
                    await send(.getMedicationResponse(.success(conditionModel)))

                } catch {
                    await send(.getMedicationResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getMedicationResponse(.success(condition)):
            state.medicationModel = condition
            state.isLoading = false
            do {
                try coreDataClient.saveResourceTree(condition)
            } catch {
                print("❌ Failed to save MEdication to Core Data: \(error)")
            }
            return .none

        case let .getMedicationResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        }
    }
}
