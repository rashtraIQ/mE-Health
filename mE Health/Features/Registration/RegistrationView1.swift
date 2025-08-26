//
//  RegistrationView1.swift
//  mE Health
//
//  # =============================================================================
//# mEinstein - CONFIDENTIAL
//#
//# Copyright ©️ 2025 mEinstein Inc. All Rights Reserved.
//#
//# NOTICE: All information contained herein is and remains the property of
//# mEinstein Inc. The intellectual and technical concepts contained herein are
//# proprietary to mEinstein Inc. and may be covered by U.S. and foreign patents,
//# patents in process, and are protected by trade secret or copyright law.
//#
//# Dissemination of this information, or reproduction of this material,
//# is strictly forbidden unless prior written permission is obtained from
//# mEinstein Inc.
//#
//# Author(s): Ishant 
//# ============================================================================= on 9/05/25.
//

import SwiftUI
import ComposableArchitecture


struct RegistrationView1: View {
    
    let store: StoreOf<RegistrationFeature>
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss)      private var dismiss
    @StateObject private var countryVM = CountryViewModel()
    private let registerStore = Store(initialState: RegistrationStep2.State()) {
        RegistrationStep2()
    }

    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                   ZStack(alignment: .topLeading) {
                       // Scrollable form
                       ScrollView {
                           VStack(spacing: 20) {
                               // Logo & subtitle
                               VStack(spacing: -10) {
                                   if colorScheme == .dark {
                                       GIFView(gifName: "ME")
                                           .frame(width: 114, height: 114)
                                           .padding(.top, 20)
                                       Text("Your shadow brain...")
                                           .fontWeight(.semibold)
                                           .foregroundColor(.white)
                                           .padding(.bottom, 30)
                                           .font(.system(size: 18))
                                   } else {
                                       GIFView(gifName: "mELogo")
                                           .frame(width: 114, height: 114)
                                           .padding(.top, 20)
                                       Text("Your shadow brain...")
                                           .fontWeight(.semibold)
                                           .foregroundColor(.black)
                                           .padding(.bottom, 30)
                                           .font(.system(size: 18))
                                   }
                               }

                               // Name fields
                               HStack(spacing: 20) {
                                   InputField(
                                       label: "First Name",
                                       icon: "personicon",
                                       placeholder: "Enter here",
                                       text: viewStore.binding(
                                           get: \.firstName,
                                           send: RegistrationFeature.Action.firstNameChanged
                                       ),
                                       showPassword: .constant(false),
                                       showValidation: viewStore.showValidationErrors,
                                       validation: { str in str.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil }
                                   )

                                   InputField(
                                       label: "Last Name",
                                       icon: "personicon",
                                       placeholder: "Enter here",
                                       text: viewStore.binding(
                                           get: \.lastName,
                                           send: RegistrationFeature.Action.lastNameChanged
                                       ),
                                       showPassword: .constant(false),
                                       showValidation: viewStore.showValidationErrors,
                                       validation: { str in str.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil }
                                   )
                               }

                               // Date of Birth
                               InputField(
                                   label: "Date Of Birth",
                                   icon: "calendaricon",
                                   placeholder: "Enter here",
                                   text: .constant(RegistrationFeature.isDateDefault(viewStore.state.birthDate) ? "" : formattedDate(viewStore.state.birthDate)),
                                   showPassword: .constant(false),
                                   onTap: { viewStore.send(.showDatePicker(true)) },
                                   showValidation: viewStore.showValidationErrors,
                                   validation: { _ in RegistrationFeature.isDateDefault(viewStore.state.birthDate) ? "Required" : nil }
                               )

                               // Email
                               InputField(
                                   label: "Email",
                                   icon: "emailicon",
                                   placeholder: "Enter here",
                                   text: viewStore.binding(
                                       get: \.email,
                                       send: RegistrationFeature.Action.emailChanged
                                   ),
                                   showPassword: .constant(false),
                                   showValidation: viewStore.showValidationErrors,
                                   validation: { str in
                                       let t = str.trimmingCharacters(in: .whitespaces)
                                       if t.isEmpty { return "Required" }
                                       let pat = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
                                       return NSPredicate(format: "SELF MATCHES %@", pat)
                                                   .evaluate(with: t) ? nil : "Please enter a valid email address."
                                   }
                               )
                               .keyboardType(.emailAddress)

                               // Country
                               HStack(spacing: 12) {
                                   InputField(
                                       label: "Country Code",
                                       icon: "magnifyingglass",
                                       placeholder: "+1",
                                       text: Binding(
                                           get: { viewStore.state.countryCode },
                                           set: { viewStore.send(.countryCodeChanged($0)) }
                                       ),
                                       showPassword: .constant(false),
                                       onTap: { viewStore.send(.showCountryPicker(true)) },
                                       showValidation: viewStore.showValidationErrors,
                                       validation: { str in str.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil }
                                   )

                                   // Phone
                                   InputField(
                                       label: "Phone No.",
                                       icon: "phoneicon",
                                       placeholder: "Enter here",
                                       text: Binding(
                                           get: { viewStore.state.phoneNumber },
                                           set: { viewStore.send(.phoneNumberChanged($0)) }
                                       ),
                                       showPassword: .constant(false),
                                       showValidation: viewStore.showValidationErrors,
                                       validation: { str in
                                           let t = str.trimmingCharacters(in: .whitespaces)
                                           if t.isEmpty { return "Required" }
                                           guard t.count == 10,
                                                 CharacterSet.decimalDigits.isSuperset(of: .init(charactersIn: t))
                                           else { return "Phone must be 10 digits" }
                                           return nil
                                       }
                                   )
                                   .keyboardType(.numberPad)
                               }

                               // Gender selection
                               HStack(spacing: 0) {
                                   let opts = ["Male", "Female", "Other"]
                                   ForEach(opts, id: \.self) { opt in
                                       Button { viewStore.send(.genderSelected(opt)) } label: {
                                           Text(opt)
                                               .fontWeight(.medium)
                                               .foregroundColor(viewStore.state.gender == opt ? .white : .primary)
                                               .frame(maxWidth: .infinity, minHeight: 36)
                                               .background(
                                                   viewStore.state.gender == opt
                                                   ? Theme.primary
                                                   : Color(UIColor.secondarySystemBackground)
                                               )
                                       }
                                       if opt != opts.last {
                                           Divider()
                                               .frame(width: 1, height: 24)
                                               .background(Color(UIColor.separator))
                                       }
                                   }
                               }
                               .clipShape(RoundedRectangle(cornerRadius: 8))

                               // Continue button
                               Button {
                                   viewStore.send(.toggleValidationErrors(true))
                                   if RegistrationFeature.validateAllFields(viewStore.state) {
                                       viewStore.send(.proceedToNext(true))
                                   }
                               } label: {
                                   HStack(spacing: 8) {
                                       Spacer()
                                       Text("Continue")
                                           .font(.system(size: 20))
                                           .fontWeight(.bold)
                                       Image("remix-icons")
                                           .resizable()
                                           .frame(width: 20, height: 20)
                                       Spacer()
                                   }
                                   .foregroundColor(.white)
                                   .frame(height: 48)
                                   .background(Theme.primary)
                                   .cornerRadius(24)
                               }
                               .padding(.top, 24)
                               .navigationDestination(
                                   isPresented: viewStore.binding(
                                       get: \.navigateNext,
                                       send: { value in .proceedToNext(value) } // new action to cleanly dismiss
                                   )
                               ) {
                                   RegistrationView2(store: registerStore)
                               }
                           }
                           .padding(.top, 70)
                           .padding(.horizontal, 20)
                       }
                       .ignoresSafeArea(edges: .top)
                       .scrollIndicators(.hidden)
                       .scrollContentBackground(.hidden)

                       // Back button overlay
                       Button {
                           viewStore.send(.proceedToNext(false))  // handle back
                       } label: {
                           Image("Back")
                               .padding(.top, 15)
                               .padding(.leading, 15)
                       }
                       .zIndex(1)
                   }
                   .tint(Theme.primary)
                   .sheet(isPresented:
                            viewStore.binding(
                                get: \.showDatePicker,
                                send: { value in .showDatePicker(value) })
                   ){
                            DatePickerPage(selectedDate:
                                            Binding(
                                               get: { viewStore.birthDate },
                                               set: { viewStore.send(.dateSelected($0)) }
                                           ))
                           .presentationDetents([.fraction(0.35)])
                           .presentationDragIndicator(.visible)
                   }
                   .sheet(isPresented:
                            viewStore.binding(
                                get: \.showCountryPicker,
                                send: { value in .showCountryPicker(value) })

                        ) {
                       CountryPickerView(
                           countryVM: countryVM,
                           selectedCode:                                             Binding(
                                get: { viewStore.countryCode },
                                set: { viewStore.send(.countryCodeChanged($0)) }),
                           isPresented:                            viewStore.binding(
                            get: \.showCountryPicker,
                            send: { value in .showCountryPicker(value) })
                       )
                   }
                   .navigationBarHidden(true)
                   .navigationBarBackButtonHidden(true)
               }
        
    }

    // MARK: - Helpers

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }


}

#Preview(body: {
    RegistrationView1(
        store: Store(initialState: RegistrationFeature.State()) {
                RegistrationFeature()
            }
        )
})
