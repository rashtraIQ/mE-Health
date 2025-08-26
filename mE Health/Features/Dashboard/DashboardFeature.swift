import ComposableArchitecture
import Foundation

var userProfileData : ProfileData?


struct DashboardFeature: Reducer {
    
    struct PersonaFeatureWrapper: Equatable, Identifiable {
        var id: UUID = UUID()
        var state: PersonaFeature.State
    }

    
    enum NavigationDestination: Equatable, Identifiable {
        case login

        var id: String {
            switch self {
            case .login: "login"
            }
        }
    }


    struct State: Equatable {
        var isLoading: Bool = false
        var showErrorAlert = false
        var errorMessage = ""
        var selectedTab: DashboardTab = .dashboard
        var selectedMenuTab: SideMenuTab = .dashboard
        var showMenu: Bool = false
        
        var personaSelectedDestination: PersonaDestination? = nil
        
        var navigationDestination: NavigationDestination? = nil
        var dashboardListState: DashboardListFeature.State? = nil
        var showDashboardList: Bool = false
        var persona: PersonaFeatureWrapper?
        var personaState: PersonaFeature.State? {
            get { persona?.state }
            set {
                if let newValue = newValue {
                    if var wrapper = persona {
                        wrapper.state = newValue
                        persona = wrapper
                    }
                } else {
                    persona = nil
                }
            }
        }
        
        var showSettings: Bool = false
        var showContactUs: Bool = false
        
        var showLogoutConfirmation = false


    }

    enum Action: Equatable {
        case onAppear
        case logoutTapped
        case tabSelected(DashboardTab)
        case tabMenuItemSelected(SideMenuTab)
        case toggleMenu(Bool)
        
        case navigationDestinationChanged(DashboardFeature.NavigationDestination?)
        case showDashboardList(Bool)
        
        case openPersona
        case closePersona
        case persona(PersonaFeature.Action)
        
        case callApi
        case userProfileResponse(TaskResult<PatientProfilResponse>)
        
        case showSettings(Bool)
        case showContactUs(Bool)

        case confirmLogout
        case cancelLogout

    }

    @Dependency(\.fhirClient) var fhirClient
    @Dependency(\.coreDataClient) var coreDataClient
    @Dependency(\.profileClient) var profileClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        
        case .onAppear:
            state.isLoading = true
            state.persona = nil
            state.navigationDestination = nil
            state.personaSelectedDestination = nil
            return .send(.callApi)
            
        case .callApi:
            guard let userId = Int(MEUtility.getME_USERID()) else {
                state.errorMessage = "User ID missing"
                state.isLoading = false
                return .none
            }
            let request = ProfileRequest(user_id: userId)
            return .run { send in
                do {
                    let result = try await profileClient.getUserProfileApi(request)
                    await send(.userProfileResponse(.success(result)))
                } catch {
                    await send(.userProfileResponse(.failure(error)))
                }
            }

        case let .userProfileResponse(.success(response)):
            userProfileData = response.data
            state.isLoading = false
            return .none

        case let .userProfileResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return .none


        case .logoutTapped:
            return .none

        case .tabSelected(let tab):
            state.selectedTab = tab
            return .none

        case let .toggleMenu(isOpen):
            state.showMenu = isOpen
            return .none

        case .tabMenuItemSelected(let item):
            switch item {
            case .persona:
                //state.persona = PersonaFeatureWrapper(state: PersonaFeature.State())
                return .send(.openPersona)

            case .logout:
                state.showLogoutConfirmation = true
                
            case .settings:
                return .send(.showSettings(true))
                
            case .contact:
                return .send(.showContactUs(true))

                
            case .dashboard:
                return .send(.tabSelected(.dashboard))
            default:
                break
            }
            return .none
            
        case .confirmLogout:
            SessionManager.shared.clearSession()
            state.navigationDestination = .login
            state.showLogoutConfirmation = false
            return .none

        case .cancelLogout:
            state.showLogoutConfirmation = false
            return .none



        case .navigationDestinationChanged(let destination):
            state.navigationDestination = destination
            return .none

        case let .showDashboardList(show):
            state.showDashboardList = show
            return .none
            
        case .persona(let action):
            switch action {
            case .itemTapped(let destination):
                state.persona?.state.selectedDestination = destination
                return .none

            case .dismissDestination:
                state.persona?.state.selectedDestination = nil
                // Navigating back from detail inside PersonaView
               // state.persona?.selectedDestination = nil
                return .none

            case .navigateBackToHomeTapped:
                // Navigating back from PersonaView to Dashboard
                state.persona = nil
                state.navigationDestination = nil
                return .none
                
            default:
                return .none
            }


        case .openPersona:
            state.persona = PersonaFeatureWrapper(state: PersonaFeature.State())
            return .none

        case .closePersona:
            state.persona = nil
            return .none
            
        case let .showSettings(show):
            state.showSettings = show
            return .none

        case let .showContactUs(show):
            state.showContactUs = show
            return .none

        }
    }

    var body: some ReducerOf<Self> {
        Reduce(self.reduce)
            .ifLet(\.personaState, action: /Action.persona) {
                PersonaFeature()
            }
    }


}



