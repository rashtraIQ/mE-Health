import SwiftUI


struct VitalsAllView: View {
    
    @Environment(\.presentationMode) var presentationMode

    let vitalPassArray : [VitalDummyData]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("List of Vitals")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                    
                    if vitalPassArray.isEmpty {
                        NoDataView()
                    } else {
                        ForEach(vitalPassArray) { vital in
                            VStack(alignment: .leading, spacing: 8) {
                                PractionerAppoitmentsCardView(
                                    name: vital.codeDisplay,
                                    dateTime: vital.formattedDate
                                )
                                .frame(height: 80)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
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

