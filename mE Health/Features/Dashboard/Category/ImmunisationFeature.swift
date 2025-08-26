
import ComposableArchitecture
import Foundation

struct ImmunisationFeature: Reducer {
    struct State: Equatable {
        var immuneModel : ImmunizationResource?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadImmunisation
        case getImmunisationResponse(Result<ImmunizationModel, FHIRAPIError>)
        case getDetailtResponse(Result<ImmunizationResource, FHIRAPIError>)
        
    }

    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.coreDataClient) var coreDataClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadImmunisation:
            
            state.isLoading = true
            state.errorMessage = ""
            return .run { send in
                do {
                    let conditionModel = try await fhirClient.getImmunization()
                    await send(.getImmunisationResponse(.success(conditionModel)))
                } catch {
                    await send(.getImmunisationResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getImmunisationResponse(.success(model)):
            let resource = model.entry?.first?.resource
            let id = resource?.id ?? ""
            return .run { send in
                do {
                    let resourceModel = try await fhirClient.getImmunizationDetail(id)
                    await send(.getDetailtResponse(.success(resourceModel)))
                } catch {
                    await send(.getDetailtResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .getImmunisationResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none
            
        case let .getDetailtResponse(.success(model)):
            state.isLoading = false
            state.errorMessage = nil
            state.immuneModel = model
            return .none

        case let .getDetailtResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        }
    }
}
