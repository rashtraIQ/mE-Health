import Foundation
import Combine

class CountryViewModel: ObservableObject {
    @Published var countries: [Country] = []

    init() {
        loadCountries()
    }

    func loadCountries() {
        guard
            let url = Bundle.main.url(forResource: "country", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            print("❌ country.json not found")
            return
        }

        do {
            let decoded = try JSONDecoder().decode([String: [Country]].self, from: data)
            countries = decoded["countries"] ?? []
        } catch {
            print("❌ Error decoding country.json:", error)
        }
    }
}

struct Country: Identifiable, Decodable {
    let id: String
    let name: String
    let code: String
}

