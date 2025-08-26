
import ComposableArchitecture
import Foundation

struct PatientFeature: Reducer {
    
    struct State: Equatable {
        var patientData: PatientModel?
        var isLoading: Bool = false
        var errorMessage = ""

    }

    enum Action: Equatable {
        case onAppear
        case patientResponse(Result<PatientModel, FHIRAPIError>)
    }
    
    @Dependency(\.fhirClient) var fhirClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        let result = try await fhirClient.fetchPatient()
                        await send(.patientResponse(.success(result)))
                    } catch {
                        await send(.patientResponse(.failure(error as? FHIRAPIError ?? .invalidResponse)))
                    }
                }

            case let .patientResponse(.success(patient)):
                state.isLoading = false
                state.patientData = patient
                
                if let reference = patient.careProvider?.first?.reference {
                    let components = reference.split(separator: "/")
                    if let last = components.last {
                        print("ID: \(last)")
                        MEUtility.setME_PRACTITIONERD(value: String(last))
                    }
                }
                return .none

            case .patientResponse(.failure):
                state.isLoading = false
                state.errorMessage = "No Data found"
                return .none

            }
        }
    }
}

