//
//  PracticesClient.swift
//  mE Health
//

import Foundation
import ComposableArchitecture
import CoreData

protocol PracticesClient {
    func getStateList() async throws -> StateModel
    func getPracticeList(state:String) async throws -> PracticesModel
}
struct ApiPracticeClient: PracticesClient {
    func getStateList() async throws -> StateModel {
        let url = Constants.API.appBaseUrl + "/api/health/practices/stats/"
        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(StateModel.self, from: data)
    }
    
    func getPracticeList(state:String) async throws -> PracticesModel {
        
        guard let token = MEUtility.getME_TOKEN() else {
            throw URLError(.userAuthenticationRequired)
        }
        let url = Constants.API.appBaseUrl + "/api/health/practices/?country=USA&search=\(state)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(PracticesModel.self, from: data)

    }
}

struct PracticesClientDependency {
    var getStateList:() async throws -> StateModel
    var getPracticeList:(_ state: String) async throws -> PracticesModel
}

enum PracticesClientKey: DependencyKey {
    static let liveValue: PracticesClientDependency = PracticesClientDependency(
        getStateList: {
            try await ApiPracticeClient().getStateList()
        }, getPracticeList: { state in
            try await ApiPracticeClient().getPracticeList(state: state)
        }
    )
}

extension DependencyValues {
    var practicesClient: PracticesClientDependency {
        get { self[PracticesClientKey.self] }
        set { self[PracticesClientKey.self] = newValue }
    }
}

struct LocalClinicStorage {
    var saveStates: ([TopStates]) async throws -> Void
    var loadStates: () async throws -> [TopStates]?
}

extension DependencyValues {
    var localClinicStorage: LocalClinicStorage {
        get { self[LocalClinicStorageKey.self] }
        set { self[LocalClinicStorageKey.self] = newValue }
    }
}

enum LocalClinicStorageKey: DependencyKey {
    static let liveValue = LocalClinicStorage(
        saveStates: { topStates in
            let context = CoreDataManager.shared.context
            // Clear existing records
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ClinicState.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(deleteRequest)

            // Save new states
            for item in topStates {
                let entity = ClinicState(context: context)
                entity.state = item.state
                entity.count = Int64(item.count ?? 0)
                entity.logo = item.logo
            }

            try context.save()
        },

        loadStates: {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<ClinicState> = ClinicState.fetchRequest()
            let results = try context.fetch(request)

            let topStates: [TopStates] = results.map {
                TopStates(
                    state: $0.state,
                    count: Int($0.count),
                    logo: $0.logo
                )
            }

            return topStates.isEmpty ? nil : topStates
        }
    )
}

