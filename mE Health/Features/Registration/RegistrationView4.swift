import SwiftUI
import ComposableArchitecture

struct RegistrationView4: View {
    @Environment(\.colorScheme) var colorScheme
    let store: StoreOf<RegistrationStep4>
    private let loginStore = Store(initialState: LoginFeature.State()) {
        LoginFeature()
    }
    

    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                
                (colorScheme == .light ? Color(.systemPink).opacity(0.1) : Color.black)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text("Welcome Back")
                            .font(.custom("Handlee", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(3.0)
                            .tint(Theme.primary)
                        
                        Text("Setting Up\nYour Profile")
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        viewStore.send(.setNavigateNext)
                    }) {
                        
                        HStack(spacing: 8) {
                            Text("All Set")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Image("remix-icons")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                        .foregroundColor(.white)
                        .frame(alignment: .center)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Theme.primary)
                        .cornerRadius(24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                    
                    
                    
                    .navigationDestination(isPresented:  viewStore.binding(
                        get: \.navigatetonext,
                        send: RegistrationStep4.Action.setNavigateNext
                    )) {
                        LoginView(store: loginStore)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}



#Preview {
    RegistrationView4(
        store: Store(
            initialState: RegistrationStep4.State(),
            reducer: {
                RegistrationStep4()
            }
        )
    )
}
