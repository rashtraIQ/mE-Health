
import ComposableArchitecture
import Foundation

// MARK: - State
struct AppFeature: Reducer {
    
    struct State: Equatable {
        var isLoading: Bool = true
        var loginState: LoginFeature.State? = nil
        var dashboardState: DashboardFeature.State? = nil
    }

    // MARK: - Action
    enum Action: Equatable {
        case onSplashAppear
        case login(LoginFeature.Action)
        case initializeLogin
        case goToDashboard(DashboardFeature.Action)
        case initializeDashboard
    }

    // MARK: - Environment
    struct Environment {
        var sessionManager: SessionManager
    }

    // MARK: - Reducer
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
            // SplashScreen logic
        case .onSplashAppear:
            state.isLoading = true
            return .run { send in
                try await Task.sleep(nanoseconds: 6_400_000_000) // 6.4 sec splash delay
                if SessionManager.shared.isLoggedIn {
                    print("go to dashbiard")
                     await send(.initializeDashboard)
                } else {
                    print("do login here")
                    await send(.initializeLogin)
                }
            }
            
        case .initializeLogin:
            guard state.loginState == nil else {
                // Already initialized, do nothing
                print("called again")
                return .none
            }
            
            state.isLoading = false
            state.loginState = LoginFeature.State()
            return .none
            
        case .initializeDashboard:
            guard state.dashboardState == nil else {
                // Already initialized, do nothing
                print("called again")
                return .none
            }
            state.isLoading = false
            state.dashboardState = DashboardFeature.State()
            return .none
            
        case .login(_):
            return .none
        case .goToDashboard(_):
            return .none
        }
    }
        
    var body: some ReducerOf<Self> {
        Reduce(self.reduce)
            .ifLet(\.loginState, action: /Action.login) {
                LoginFeature()
            }
            .ifLet(\.dashboardState, action: /Action.goToDashboard) {
                DashboardFeature()
            }
    }

    
}


