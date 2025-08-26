//
//  SelectGoalDatePicker.swift
//  mE Health
//
//  Created by Ishant Tiwari on 01/08/25.
//

import SwiftUI

struct SelectGoalDatePicker: View {
    @Binding var selectedDateString: String
    @State private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    

    
    var body: some View {
            VStack() {
                
                HStack {
                    CustomBackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                .padding(.leading, 20)
               
                Text("Add a Goal")
                   .font(.montserrat(32, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 30)
                
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: Date()...Date.distantFuture,
                    displayedComponents: [.date]
                ).labelsHidden()
                .datePickerStyle(.wheel)
                
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
              
               
                Button(action: {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    selectedDateString = formatter.string(from: selectedDate)
                    presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Add")
                        .foregroundColor(.white)
                         .font(.montserrat(16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: Constants.API.PrimaryColorHex))
                        .cornerRadius(28)
                }.padding()
            }.navigationBarBackButtonHidden(true)
           
             Spacer()
            
       
        }
        
    
}
