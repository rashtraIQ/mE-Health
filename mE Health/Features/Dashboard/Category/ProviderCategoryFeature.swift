import ComposableArchitecture
import Foundation

struct ProviderCategoryFeature: Reducer {
    
    struct State: Equatable {
        var practitioner: Practitioner?
        var practitionerRole: PractitionerRole?
        var isLoading: Bool = false
        var errorMessage: String?
    }

    enum Action: Equatable {
        case loadProviders
        case loadProvidersResponse(Result<Practitioner, FHIRAPIError>)

        case loadRoles(practitionerId: String)
        case loadRolesResponse(Result<PractitionerRole, FHIRAPIError>)

        case loadEncounters(practitionerId: String)
        case loadEncountersResponse(practitionerId: String, Result<PractitionerRole, FHIRAPIError>)
    }

    @Dependency(\.fhirClient) var fhirClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

        case .loadProviders:
            
            state.isLoading = true
            state.errorMessage = nil

            return .run { send in
                do {
                    let practitioners = try await fhirClient.getPractitioner()
                    await send(.loadProvidersResponse(.success(practitioners)))
                    await send(.loadRoles(practitionerId: practitioners.id ?? ""))
                    await send(.loadEncounters(practitionerId: practitioners.id ?? ""))

                } catch {
                    await send(.loadProvidersResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .loadProvidersResponse(.success(practitioners)):
            state.practitioner = practitioners
            state.isLoading = false
            return .none

        case let .loadProvidersResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = "Failed to load providers: \(error.localizedDescription)"
            return .none

        case let .loadRoles(practitionerId):
            return .run { send in
                do {
                    let roles = try await fhirClient.getPractitionerRoles(practitionerId)
                    await send(.loadRolesResponse(.success(roles)))
                } catch {
                    await send(.loadRolesResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .loadRolesResponse(.success(roles)):
            state.practitionerRole = roles
            return .none

        case let .loadRolesResponse(.failure(error)):
            state.errorMessage = "Failed to load roles: \(error.localizedDescription)"
            return .none

        case let .loadEncounters(practitionerId):
            return .run { send in
                do {
                    let encounters = try await fhirClient.getEncounters(practitionerId)
                    await send(.loadEncountersResponse(practitionerId: practitionerId, .success(encounters)))
                } catch {
                    await send(.loadEncountersResponse(practitionerId: practitionerId, .failure(error as? FHIRAPIError ?? .invalidResponse)))
                }
            }

        case let .loadEncountersResponse(practitionerId, .success(encounters)):
            return .none

        case let .loadEncountersResponse(_, .failure(error)):
            state.errorMessage = "Failed to load encounters: \(error.localizedDescription)"
            return .none
        }
    }
}

