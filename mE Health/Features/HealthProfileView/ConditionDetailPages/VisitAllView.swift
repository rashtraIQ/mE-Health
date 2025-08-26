import SwiftUI

struct VisitAllView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var filteredVisits: [VisitDummyData]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("List of Visits")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                    
                    if filteredVisits.isEmpty {
                        NoDataView()
                    } else {
                        
                        ForEach(filteredVisits) { visit in
                            PractionerAppoitmentsCardView(
                                name: visit.description,
                                dateTime: visit.formattedDate
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

