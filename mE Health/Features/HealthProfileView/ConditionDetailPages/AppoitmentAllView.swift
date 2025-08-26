
import SwiftUI

struct AppoitmentAllView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var filteredAppointments: [AppointmentData] = []
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("List of Appoitments")
                       .font(.montserrat(24, weight: .bold))
                        .padding(.horizontal)
                    
                    if filteredAppointments.isEmpty {
                        NoDataView()
                    } else {
                        
                        ForEach(filteredAppointments) { appointment in
                            PractionerAppoitmentsCardView(
                                name: appointment.practitionerName,
                                dateTime: appointment.formattedStartDate
                            )
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)

                        }
                    }
                }
                .padding(.horizontal,16)
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGray6).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

