import SwiftUI

struct CountryPickerView: View {
    @ObservedObject var countryVM: CountryViewModel
    @Binding var selectedCode: String
    @Binding var isPresented: Bool

    @State private var searchText = ""
    
    @Environment(\.colorScheme) private var colorScheme


    private var filteredCountries: [Country] {
        guard !searchText.isEmpty else { return countryVM.countries }
        return countryVM.countries.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.contains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 1) Custom drag indicator
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(Color(.systemGray4))
                .padding(.top, 8)

            // 2) Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.primary)
                TextField("Search Country Code here", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .doneToolbar()
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
             .overlay(
                 RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .light ? Color(.separator) : Theme.labelBorders, lineWidth: 1)
             )
            .padding(.horizontal)
            .padding(.top, 8)


            // 3) Scrollable list of country “cards”
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredCountries) { country in
                        Button(action: {
                            selectedCode = country.code
                            isPresented = false
                        }) {
                            HStack {
                                Image(systemName: "tag")
                                    .foregroundColor(Theme.primary)
                                Text(country.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(country.code)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                colorScheme == .dark ? Theme.gray : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)


                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}
