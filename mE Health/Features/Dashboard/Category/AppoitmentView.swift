import SwiftUI
import ComposableArchitecture

struct AppoitmentView: View {
    
    let store: StoreOf<AppoitmentFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    
                    if viewStore.isLoading {
                        ProgressView("Loading AppoitmentView Data...")
                    }
                    else if viewStore.errorMessage != nil {
                        Text("No Data found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                    }
                    else {
                        
                        let startTime = viewStore.appoitmentModel?.start ?? ""
                        let endTime = viewStore.appoitmentModel?.end ?? ""
                        let desc = viewStore.appoitmentModel?.patientInstruction ?? ""
                        let code = viewStore.appoitmentModel?.appointmentType?.coding?.first?.code ?? ""
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("AppoitmentView Data")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "startTime:", value: startTime, icon: "calendar.badge.clock")
                            conditionRow(title: "endTime:", value: endTime, icon: "waveform.path.ecg")
                            conditionRow(title: "status:", value: "", icon: "calendar")
                            conditionRow(title: "description:", value: desc, icon: "calendar")
                            conditionRow(title: "reasonCode:", value: code, icon: "calendar")

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
                .navigationTitle("Appoitment")
            }
            .onAppear {
                viewStore.send(.loadAppoinment)
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



