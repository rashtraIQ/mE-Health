import SwiftUI
import ComposableArchitecture

struct PatientView: View {
    
    let store: StoreOf<PatientFeature>
    
    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    if viewStore.isLoading {
                        ProgressView("Loading Patient Data...")
                    } else {
                        
                        let patientName = viewStore.patientData?.name?.first?.text ?? ""
                        let patientId = viewStore.patientData?.id ?? ""

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Loading Patient Data")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            conditionRow(title: "patientId:", value: patientId, icon: "lungs.fill")
                            conditionRow(title: "name:", value: patientName, icon: "calendar.badge.clock")
                            conditionRow(title: "birthDate:", value: "1985-08-01", icon: "waveform.path.ecg")
                            conditionRow(title: "gender:", value: "Male", icon: "calendar")
                            conditionRow(title: "address:", value: "", icon: "calendar")
                            conditionRow(title: "telecom:", value: "608-555-5555", icon: "calendar")
                            conditionRow(title: "identifier:", value: "", icon: "calendar")
                            conditionRow(title: "maritalStatus:", value: "", icon: "calendar")
                            conditionRow(title: "communication:", value: "", icon: "calendar")

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
                .navigationTitle("Patient")
            }
            .onAppear {
                viewStore.send(.onAppear)
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


//
//
