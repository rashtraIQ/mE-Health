import SwiftUI
import ComposableArchitecture

struct RegistrationView2: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode

    let store: StoreOf<RegistrationStep2>
    private let registerStore = Store(initialState: RegistrationStep3.State()) {
        RegistrationStep3()
    }

    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .topLeading) {
                
                // Background adapts to light/dark
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()
                
                
                ScrollView (showsIndicators: false){
                    
                    VStack(spacing: 15) {
                        // Back button
                        
                        // .ignoresSafeArea(edges: .top)
                        
                        // Logo & Tagline
                        if colorScheme == .dark {
                            GIFView(gifName: "ME")
                                .frame(width: 133, height: 133)
                                .padding(.top,-10)
                            Text("Your shadow brain...")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Theme.gray)
                                .padding(.top,-30)
                            
                        } else {
                            GIFView(gifName: "mELogo")
                                .frame(width: 133, height: 133)
                                .padding(.top,-10)
                            Text("Your shadow brain...")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.top,-30)
                            
                        }
                        
                        Spacer()
                        
                        // Form fields
                        
                        
                        VStack(spacing: 20) {
                            InputField(
                                label: "Address 1",
                                icon: "mapicon",
                                placeholder: "Street Address (e.g., 123 Main St)",
                                text: viewStore.binding(
                                    get: \.address1,
                                    send: RegistrationStep2.Action.updateAddress1
                                ),
                                showPassword: .constant(false),
                                showValidation: viewStore.showValidation,
                                validation: { _ in
                                    viewStore.address1.isEmpty ? "Address is required" : nil
                                }
                            )
                            
                            InputField(
                                label: "Address 2",
                                icon: "mapicon",
                                placeholder: "Apt/Unit # e.g., Apt 4B, Suit 200",
                                text: viewStore.binding(
                                    get: \.address2,
                                    send: RegistrationStep2.Action.updateAddress2
                                ),
                                showPassword: .constant(false),
                                showValidation: viewStore.showValidation,
                                validation: { _ in
                                    viewStore.address1.isEmpty ? "Address is required" : nil
                                }
                            )
                            
                            InputField(
                                label: "Zip Code",
                                icon: "leading icon",
                                placeholder: "Enter here",
                                text: viewStore.binding(
                                    get: \.zipCode,
                                    send: RegistrationStep2.Action.updateZipCode
                                ),
                                showPassword: .constant(false),
                                showValidation: viewStore.showValidation,
                                validation: { _ in
                                    viewStore.zipCode.isEmpty ? "Enter a valid 6-digit Zip Code" : nil
                                }
                            ).keyboardType(.numberPad)
                            
                            InputField(
                                label: "Password",
                                icon: "lockicon",
                                placeholder: "Enter Password",
                                text:  viewStore.binding(
                                    get: \.password,
                                    send: RegistrationStep2.Action.updatePassword
                                ),
                                isSecure: true,
                                showPassword: viewStore.binding(
                                    get: \.showPassword,
                                    send: { _ in RegistrationStep2.Action.toggleShowPassword }
                                ),
                                showValidation: viewStore.showValidation,
                                validation: { _ in
                                    viewStore.password.isEmpty ? "Must be at least 8 characters" : nil
                                }
                            )
                            
                            InputField(
                                label: "Confirm Password",
                                icon: "lockicon",
                                placeholder: "Enter Password",
                                text: viewStore.binding(
                                    get: \.confirmPassword,
                                    send: RegistrationStep2.Action.updateConfirmPassword)
                                ,
                                isSecure: true,
                                showPassword: viewStore.binding(
                                    get: \.showPassword,
                                    send: { _ in RegistrationStep2.Action.toggleShowPassword }
                                ),
                                showValidation: viewStore.showValidation,
                                validation: { _ in
                                    viewStore.confirmPassword.isEmpty ? "Passwords do not match" : nil
                                }
                            )
                        }
                        .padding(.horizontal)
                        
                        
                        // Continue button
                        Button {
                            viewStore.send(.validateAndProceed)
                        } label: {
                            HStack(spacing: 8) {
                                Text("Continue")
                                    .font(.headline)
                                Image("remix-icons")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity,
                                   minHeight: 48,
                                   alignment: .center)
                            .background(Theme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top)
                        
                        
                        
                        
                        // Navigate when valid
                        .navigationDestination(isPresented: viewStore.binding(
                            get: \.navigateNext,
                            send: { _ in .validateAndProceed } // new action to cleanly dismiss
                        )) {
                            RegistrationView3(store: registerStore)
                        }
                    }
                }
                .padding(.top)
                .scrollContentBackground(.hidden)
                
                // button overlay
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("Back")
                        .padding(.top, 20)
                        .padding(.leading, 8)
                }
                .zIndex(1)
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    

    
}


#Preview {
    RegistrationView2(
        store: Store(
            initialState: RegistrationStep2.State(),
            reducer: {
                RegistrationStep2()
            }
        )
    )
}
