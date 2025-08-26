//
//  DateCardView.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import SwiftUI
import Foundation

struct DateCardView: View {
    let title: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.montserrat(16, weight: .bold))
                .foregroundColor(Color.black)

            HStack(spacing: 8) {
                Image("anniversary")
                    .foregroundColor(Color(hex: "FF6605"))
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(date)
                        .font(.montserrat(14, weight: .medium))
                        .foregroundColor(Color.black)
                    
                    Rectangle()
                        .fill(Color(hex: "FF6605"))
                        .frame(height: 2)
                }
            }

            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 6)
        .frame(height:70)
    }
}

struct DatePickerModalView: View {
    let title: String
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    var minimumDate: Date? = nil
    var maximumDate:Date? = nil

    var dateRange: ClosedRange<Date> {
        if let min = minimumDate {
            return min...Date.distantFuture
        } else {
            return Date.distantPast...Date.distantFuture
        }
    }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 24) {
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "FF6605"))
                            .font(.system(size: 20, weight: .medium))
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40) // Adjust for status bar

                
                Spacer()
                
                Text("Select a Date")
                    .font(.montserrat(24, weight: .semibold))
                    .foregroundColor(Color.black)
                
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: dateRange,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(Color.white)
                .accentColor(Color(hex: "FF6605"))

                Spacer()
            }
        }
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: isPresented)
    }
}




