//
//  LabsAllView.swift
//  mE Health
//
//  Created by Rashida on 14/07/25.
//

import SwiftUI

struct LabsAllView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let array: [LabDummyData]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("List of Labs")
                       .font(.montserrat(32, weight: .bold))
                        .padding(.horizontal)
                    
                    if array.isEmpty {
                        NoDataView()
                    } else {
                        ForEach(array) { lab in
                            HStack(spacing: 12) {
                                Image("date_placeholder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(hex: "FF6605"))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lab.codeDisplay)
                                        .font(.montserrat(16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(lab.formattedDate)
                                         .font(.montserrat(12, weight: .regular))
                                        .foregroundColor(Color(hex: "FF6605"))
                                }
                            }
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

