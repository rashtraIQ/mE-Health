//
//  SubjectPopUpView.swift
//  mE Health
//
//  Created by Rashida on 24/07/25.
//

import SwiftUI
struct SubjectPopUpView: View {

    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Binding var selectedSubject: String
    
    private let options = [
        "Application Bugs",
        "Application Feedback",
        "Application Support",
        "Business Claim issues",
        "Business Claim Registration",
        "Feature Request",
        "Investor Enquiries",
        "Technical Help",
        "General Questions"
    ]

    @State private var selectedOption: String = ""
    var onDismiss: (() -> Void)? = nil
    
    
    var body: some View {
        ZStack {
            // Background Dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewControllerHolder?.dismiss(animated: true) {
                        onDismiss?()
                    }
                }

            VStack(spacing: 0) {
                Spacer()

                ZStack(alignment: .top) {
                    VStack(spacing: 16) {
                        
                        
                        Text("Please Select Subject")
                            .font(.montserrat(22, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top,24)


                        Spacer(minLength: 12)
                        // Subject List
                        ScrollView(showsIndicators: false) {
                                             VStack(spacing: 0) {
                                                 ForEach(options, id: \.self) { option in
                                                     HStack {
                                                         Image(selectedOption == option ? "radio_select" : "radio_deselect")

                                                         Text(option)
                                                             .foregroundColor(.black)
                                                              .font(.montserrat(16, weight: .regular))

                                                         Spacer()
                                                     }
                                                     .padding(.vertical, 12)
                                                     .contentShape(Rectangle())
                                                     .onTapGesture {
                                                         selectedOption = option
                                                     }

                                                     Divider()
                                                 }
                                             }
                                             .padding(.horizontal)
                                         }

                        // Apply Button
                        Button(action: {
                            if !selectedOption.isEmpty {
                                selectedSubject = selectedOption
                            }
                            viewControllerHolder?.dismiss(animated: true) {
                                onDismiss?()
                            }
                        }) {
                            Text("Apply")
                                .foregroundColor(.white)
                                .font(.montserrat(16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: Constants.API.PrimaryColorHex))
                                .cornerRadius(28)
                        }
                        .frame(width: 180, height: 45)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.75)
                    .background(
                        RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                            .fill(Color(hex: "F5F5FC"))
                    )
                    .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                    .shadow(radius: 10)

                    // Close Button
                    Button(action: {
                        viewControllerHolder?.dismiss(animated: true)
                    }) {
                        Image("close")
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "F5F5FC"))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.top, -64)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            selectedOption = selectedSubject
        }
    }

}
