//
//  Untitled.swift
//  mE Health
//
//  Created by Rashida on 20/06/25.
//
import SwiftUI
import ComposableArchitecture


struct FilterPopupView: View {
    let store: StoreOf<HeaderFeature>
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {

                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewControllerHolder?.dismiss(animated: true) {
                            viewStore.send(.dismissSheet)
                        }
                    }
                
                VStack(spacing: 0) {
                    Spacer()

                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            
                            Spacer(minLength: 32)
                            
                            
                            ScrollView {
                                
                                VStack(spacing: 16) {
                                    
                                    ForEach(viewStore.availableFilters, id: \.self) { filter in
                                        Button {
                                            viewStore.send(.toggleFilter(filter))
                                        } label: {
                                            HStack {
                                                Image(systemName: viewStore.selectedFilters.contains(filter) ? "checkmark.square.fill" : "square")
                                                    .foregroundColor(.black)
                                                Text(filter.label)
                                                    .foregroundColor(.black)
                                                     .font(.montserrat(16, weight: .regular))
                                                Spacer()
                                            }
                                            .padding()
                                            .frame(height: 64)
                                            .background(Color.white)
                                            .cornerRadius(6)
                                            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.bottom, 16)
                            }
                            .frame(
                                maxHeight: min(CGFloat(viewStore.availableFilters.count) * 80, UIScreen.main.bounds.height * 0.38)
                            )

                            Button(action: {
                                viewControllerHolder?.dismiss(animated: true) {
                                    viewStore.send(.applyFilters)
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
                            .padding(.top, 44)
                            .padding(.bottom, 32)

                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.54)
                        .background(
                            RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                                .fill(Color(hex: "F5F5FC"))
                        )
                        .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
                        .shadow(radius: 10)


                        // Close Button (X)
                        Button(action: {
                            viewControllerHolder?.dismiss(animated: true) {
                                viewStore.send(.dismissSheet)
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
}

#Preview {
    FilterPopupView(
        store: Store(
            initialState: HeaderFeature.State(
                isFilterPresented: true,
                selectedFilters: []
            ),
            reducer: { HeaderFeature() }
        )
    )
}
