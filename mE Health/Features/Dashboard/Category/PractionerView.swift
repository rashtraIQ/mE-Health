import SwiftUI
import ComposableArchitecture

struct PractionerView: View {
    
    let store: StoreOf<PractionerFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Practioner Data...")
                    } else if viewStore.errorMessage == "No Data found" {
                        Text("No Data found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                    }
                    else {
                        let name = viewStore.practionerModel?.name?.first?.text ?? ""
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Loading Practioner Data")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "Name:", value: name, icon: "lungs.fill")

                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                        .padding()
                    }
                }
                .navigationTitle("Practioner")
            }
            .onAppear {
                    viewStore.send(.loadPractioner)  
            }

        }
    }

    @ViewBuilder
    private func conditionRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical, 4)
    }
}



