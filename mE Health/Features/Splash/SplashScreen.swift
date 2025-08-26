import SwiftUI
import ComposableArchitecture



struct SplashScreen: View {
    
    let store: Store<AppFeature.State, AppFeature.Action>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLoading {
                    ZStack {
                        Color(.systemBackground).ignoresSafeArea()
                        VStack(spacing: 1) {
                            if colorScheme == .dark {
                                GIFView(gifName: "ME")
                                    .frame(width: 212, height: 212)
                            } else {
                                GIFView(gifName: "mELogo")
                                    .frame(width: 212, height: 212)
                            }

                            Text("mE Health")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .frame(width: 212, height: 46)
                                .padding(.top, -20)
                        }
                    }
                    .onAppear {
                        viewStore.send(.onSplashAppear)
                    }
                }
                else if viewStore.loginState != nil {
                    LoginView(
                        store: Store(
                            initialState: LoginFeature.State(),
                            reducer: {
                                LoginFeature()
                            }
                        )
                    )
                    }
                else if viewStore.dashboardState != nil {
                    DashboardView(
                        store: Store(
                            initialState: DashboardFeature.State(),
                            reducer: {
                                DashboardFeature()
                            }
                        )
                    )
                }

            }
        }
    }
}




#Preview {
    NavigationStack {
            SplashScreen(
                store: Store(
                    initialState: AppFeature.State(),
                    reducer: {
                        AppFeature()
                    }
                )
            )
        }
}
