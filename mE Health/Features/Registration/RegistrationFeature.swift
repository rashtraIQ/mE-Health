
import ComposableArchitecture
import Foundation

struct RegistrationFeature: Reducer {
    
    struct State: Equatable {
        var firstName: String = ""
        var lastName: String = ""
        var birthDate: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)) ?? Date()
        var email: String = ""
        var countryCode: String = ""
        var phoneNumber: String = ""
        var gender: String = "Male"
        var showCountryPicker: Bool = false
        var showDatePicker: Bool = false
        var showValidationErrors: Bool = false
        var navigateNext: Bool = false
        var showPassword: Bool = false
        var step2 = RegistrationStep2.State()
        var step3 = RegistrationStep3.State()
        var step4 = RegistrationStep4.State()
    }

    enum Action: Equatable {
        case firstNameChanged(String)
        case lastNameChanged(String)
        case birthDateChanged(Date)
        case emailChanged(String)
        case countryCodeChanged(String)
        case phoneNumberChanged(String)
        case genderSelected(String)
        case showDatePicker(Bool)
        case showCountryPicker(Bool)
        case toggleValidationErrors(Bool)
        case continueTapped
        case proceedToNext(Bool)
        case togglePasswordVisibility
        case setValidationErrors(Bool)
        case dateSelected(Date)
        case step2(RegistrationStep2.Action)
        case step3(RegistrationStep3.Action)
        case step4(RegistrationStep4.Action)

    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .firstNameChanged(value):
            state.firstName = value
            state.showValidationErrors = false
            return .none

        case let .lastNameChanged(value):
            state.lastName = value
            state.showValidationErrors = false
            return .none

        case let .birthDateChanged(date):
            state.birthDate = date
            state.showValidationErrors = false
            return .none

        case let .emailChanged(email):
            state.email = email
            state.showValidationErrors = false
            return .none

        case let .countryCodeChanged(code):
            state.countryCode = code
            state.showValidationErrors = false
            return .none

        case let .phoneNumberChanged(number):
            state.phoneNumber = String(number.prefix(10).filter(\.isWholeNumber))
            state.showValidationErrors = false
            return .none

        case let .genderSelected(gender):
            state.gender = gender
            return .none
            
        case let .dateSelected(date):
            state.birthDate = date
            return .none

        case let .showDatePicker(show):
            state.showDatePicker = show
            return .none

        case let .showCountryPicker(show):
            state.showCountryPicker = show
            return .none

        case let .toggleValidationErrors(show):
            state.showValidationErrors = show
            return .none

        case .continueTapped:
            state.showValidationErrors = true
            if Self.validateAllFields(state) {
                state.navigateNext = true
            }
            return .none

        case let .proceedToNext(value):
            state.navigateNext = value
            return .none
            
        case .togglePasswordVisibility:
            state.showPassword.toggle()
            return .none
        case .setValidationErrors(let showErrors):
            state.showValidationErrors = showErrors
            return .none

        case .step2(_):
            return .none
        case .step3(_):
            return .none
        case .step4(_):
            return .none
        }
    }

    static func validateAllFields(_ state: State) -> Bool {
        return !state.firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !state.lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !isDateDefault(state.birthDate) &&
               isValidEmail(state.email) &&
               !state.countryCode.trimmingCharacters(in: .whitespaces).isEmpty &&
               state.phoneNumber.count == 10
    }

    static func isDateDefault(_ date: Date) -> Bool {
        let defaultDate = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)) ?? Date()
        return Calendar.current.isDate(date, inSameDayAs: defaultDate)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.step2, action: /Action.step2) {
            RegistrationStep2()
        }
        Scope(state: \.step3, action: /Action.step3) {
            RegistrationStep3()
        }
        Scope(state: \.step4, action: /Action.step4) {
            RegistrationStep4()
        }
    }

}



struct RegistrationStep2: Reducer {
    struct State: Equatable {
        var address1 = ""
        var address2 = ""
        var zipCode = ""
        var password = ""
        var confirmPassword = ""
        var showPassword = false
        var showConfirmPass = false
        var showValidation = false
        var navigateNext = false
    }

    enum Action: Equatable {
        case updateAddress1(String)
        case updateAddress2(String)
        case updateZipCode(String)
        case updatePassword(String)
        case updateConfirmPassword(String)
        case toggleShowPassword
        case toggleShowConfirmPass
        case setShowValidation(Bool)
        case validateAndProceed
        case setNavigateNext(Bool)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .updateAddress1(let val):
            state.address1 = val
            return .none

        case .updateAddress2(let val):
            state.address2 = val
            return .none

        case .updateZipCode(let val):
            state.zipCode = val
            return .none

        case .updatePassword(let val):
            state.password = val
            return .none

        case .updateConfirmPassword(let val):
            state.confirmPassword = val
            return .none

        case .toggleShowPassword:
            state.showPassword.toggle()
            return .none

        case .toggleShowConfirmPass:
            state.showConfirmPass.toggle()
            return .none

        case .setShowValidation(let show):
            state.showValidation = show
            return .none

        case .validateAndProceed:
            state.showValidation = true
            if validate(state: state) {
                state.navigateNext = true
            }
            return .none

        case .setNavigateNext(let val):
            state.navigateNext = val
            return .none
        }
    }

    private func validate(state: State) -> Bool {
        return state.address1Error == nil &&
               state.zipCodeError == nil &&
               state.passwordError == nil &&
               state.confirmPasswordError == nil
    }

}

struct RegistrationStep3: Reducer {
    struct State: Equatable {
        var selectedOption: String = "From friends or family"
        var navigateToNextPage = false

        let options: [RadioButtonOption] = [
            .init(title: "From friends or family"),
            .init(title: "Social media"),
            .init(title: "Online advertisement"),
            .init(title: "Search engine")
        ]
    }

    enum Action: Equatable {
        case optionSelected(String)
        case continueTapped
        case setNavigation(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .optionSelected(let option):
                state.selectedOption = option
                return .none

            case .continueTapped:
                state.navigateToNextPage = true
                return .none

            case .setNavigation(let value):
                state.navigateToNextPage = value
                return .none
            }
        }
    }
}

struct RegistrationStep4: Reducer {
    struct State: Equatable {
        var navigatetonext = false
    }

    enum Action: Equatable {
        case setNavigateNext
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setNavigateNext:
            state.navigatetonext = true
            return .none
        }
    }
}

// MARK: - Validation Extensions
extension RegistrationStep2.State {
    var address1Error: String? {
        guard showValidation else { return nil }
        return address1.isEmpty ? "Address is required" : nil
    }

    var zipCodeError: String? {
        guard showValidation else { return nil }
        if zipCode.isEmpty { return "Zip Code is required" }
        let valid = zipCode.range(of: "^\\d{6}$", options: .regularExpression) != nil
        return valid ? nil : "Enter a valid 6-digit Zip Code"
    }

    var passwordError: String? {
        guard showValidation else { return nil }
        if password.isEmpty { return "Password is required" }
        return password.count < 8 ? "Must be at least 8 characters" : nil
    }

    var confirmPasswordError: String? {
        guard showValidation else { return nil }
        if confirmPassword.isEmpty { return "Please confirm your password" }
        return confirmPassword != password ? "Passwords do not match" : nil
    }
}


