//
//  AdviceFilterView.swift
//  mE Health
//
//  Created by Rashida on 23/06/25.
//
import Foundation
import SwiftUI

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case fav = "Fav"
    case ignore = "Ignore"
    case review = "Review"
    case read = "Read"
    case unread = "Unread"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .all: return "Filter_fill"
        case .fav: return "Like"
        case .ignore: return "Ignore"
        case .review: return "filter"
        case .read: return "tick"
        case .unread: return "married"
        }
    }
}

struct AdviceFilterView: View {
    @Binding var selectedFilters: Set<FilterOption>
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    var dismiss: () -> Void
    
    var body: some View {
        
        ZStack {

            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewControllerHolder?.dismiss(animated: true) {
                        dismiss()
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()

                ZStack(alignment: .top) {
                    
                    VStack(spacing: 16) {
                        
                        Spacer(minLength: 12)
                        
                        // Filter container
                        VStack(spacing: 16) {
                            ForEach(FilterOption.allCases) { option in
                                HStack {
                                    Image(option.iconName)
                                        .foregroundColor(Color(hex: Constants.API.PrimaryColorHex))

                                    Text(option.rawValue)
                                        .font(.montserrat(16, weight: .medium))

                                    Spacer()

                                    Image(systemName: selectedFilters.contains(option) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(selectedFilters.contains(option) ? Color(hex: Constants.API.PrimaryColorHex) : .gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(option == .fav && selectedFilters.contains(option) ? Color.purple : Color.clear, lineWidth: 0)
                                        )
                                )
                                .onTapGesture {
                                    if selectedFilters.contains(option) {
                                           selectedFilters.remove(option)
                                       } else {
                                           if option == .all {
                                               selectedFilters = [.all]
                                           } else {
                                               selectedFilters.remove(.all)
                                               selectedFilters.insert(option)
                                           }
                                       }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedCorner(radius: 32, corners: [.topLeft, .topRight])
                                .fill(Color(hex: "#F5F5FB"))
                                .ignoresSafeArea(edges: .bottom)
                        )

                        Button(action: {
                            viewControllerHolder?.dismiss(animated: true) {
                                    dismiss() 
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
                        .padding(.top, 32)
                        .padding(.bottom, 32)

                    }
                    .padding()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                    .background(
                        RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                            .fill(Color(hex: "F5F5FC"))
                    )
                    .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                    .shadow(radius: 10)


                    // Close Button (X)
                    Button(action: {
                        viewControllerHolder?.dismiss(animated: true) {
                            dismiss()
                        }
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

    }
}

