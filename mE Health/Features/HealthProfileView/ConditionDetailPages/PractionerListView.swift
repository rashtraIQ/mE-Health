import SwiftUI


struct PractionerListView: View {

    @Environment(\.presentationMode) var presentationMode
    let arrayItem : [PractitionerDisplay]
    
    @State private var showDetail = false
    let condition: ConditionDummyData
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("List Of Practitioners")
               .font(.montserrat(32, weight: .bold))
                .padding(.horizontal)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if arrayItem.isEmpty {
                        NoDataView()
                    } else {
                        ForEach(arrayItem) { item in
                            PracItemCardView(item: item) {
                                // Your action here
                               // showDetail = true
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // align cards left full width
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            NavigationLink(
                destination: TreatmentDetailView(condition: condition),
                isActive: $showDetail,
                label: {
                    EmptyView()
                })

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


struct PracItemCardView: View {
    
    let item : PractitionerDisplay
    let onTap: () -> Void
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack {
                Image("ME-Logo") // Replace with actual image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.montserrat(18, weight: .medium))
                        .foregroundColor(Color(hex: "FF6605"))
                    Text(item.organizationName)
                         .font(.montserrat(14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
//                Image(systemName: "arrow.right")
//                    .foregroundColor(Color.black)
            }
            .padding(.horizontal)
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
        .padding(4)
        .onTapGesture {
            onTap()
        }

    }
}


