import SwiftUI
import ComposableArchitecture

struct RadioButtonOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

struct RadioButtonRow: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Orange ring when selected, gray ring when not
                Circle()
                    .stroke(isSelected ? Theme.primary : Theme.labelBorders, lineWidth: 6)
                    .frame(width: 16, height: 16)

                Text(label)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding()
            // Adaptive background for light/dark mode
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(1), lineWidth: 1)
            )
        }
    }
}

struct RegistrationView3: View {

    @Environment(\.colorScheme) private var colorScheme
    let store: StoreOf<RegistrationStep3>
    private let registerStore = Store(initialState: RegistrationStep4.State()) {
        RegistrationStep4()
    }

    var body: some View {
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                // Full-screen adaptive background
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer().frame(height: 10)
                    
                    // Title
                    HStack(spacing: 4) {
                        Text("Where did you hear about")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Image(colorScheme == .dark ? "ME-Dark" : "ME-Logo 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 62, height: 62)
                            .padding(.bottom, 29)
                        
                        Text("?")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Radio Buttons
                    VStack(spacing: 25) {
                        ForEach(viewStore.options) { option in
                            RadioButtonRow(
                                label: option.title,
                                isSelected: viewStore.selectedOption == option.title
                            ) {
                                viewStore.send(.optionSelected(option.title))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Continue Button
                    Button {
                        viewStore.send(.continueTapped)
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Theme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                    .navigationDestination(isPresented: viewStore.binding(
                        get: \.navigateToNextPage,
                        send: RegistrationStep3.Action.setNavigation
                    )) {
                        RegistrationView4(store:registerStore)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    RegistrationView3(
        store: Store(
            initialState: RegistrationStep3.State(),
            reducer: {
                RegistrationStep3()
            }
        )
    )
}
