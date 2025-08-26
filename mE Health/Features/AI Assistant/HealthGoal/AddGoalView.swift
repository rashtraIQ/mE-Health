
//
//  AddGoalView.swift
//  mE Health
//
//  Created by Ishant Tiwari on 01/08/25.
//




import SwiftUI
import ComposableArchitecture

struct AddGoalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showSubjectSheet = false
    @State private var selectedDate = "Select Date"
    @State private var commentText = ""
    
    @State private var selectedTab: DashboardTab = .menu
    @State private var showMenu: Bool = false
    @State private var selectedMenuTab: SideMenuTab = .dashboard
    @State private var navigateToDashboard = false
    @State private var navigateToPersona = false
    @State private var navigateToSettings = false
    
    @State private var navigateToGoalDate = false
    
    @State private var isSubjectPopupPresented = false
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
   // var onBackgetDate: (String) -> Void
    
    @FocusState private var isTextEditorFocused: Bool


    var body: some View {
        
        MainLayout(
            selectedTab: $selectedTab,
            showMenu: $showMenu,
            selectedMenuTab: selectedMenuTab,
            onMenuItemTap: { tab in
                selectedMenuTab = tab
                showMenu = false
                
                // Optional: route or update state
                if tab == .dashboard {
                    navigateToDashboard = true
                    
                }
                else if tab == .persona {
                    navigateToPersona = true
                }
                else if tab == .settings {
                    navigateToSettings = true
                }

                
            }
            ,
            onDashboardTabTapped: {
                    navigateToDashboard = true
                }
        )
       {
            GeometryReader { geometry in
                let primaryColor = Color(hex: Constants.API.PrimaryColorHex)

                ZStack(alignment: .topLeading) {
                    Color.white.ignoresSafeArea()


                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            //Spacer().frame(height: 24)
                            
                            HStack {
                                CustomBackButton {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                Spacer()
                            }
                            .padding(.top, 0)
                          
                                // Header Text
                                Text("Add a Goal")
                                   .font(.montserrat(32, weight: .bold))
                                    .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Describe")
                                    .font(.montserrat(12, weight: .semibold))
                                    .foregroundColor(.black)

                                HStack(alignment: .top, spacing: 8) {
                                    Image("msg_icon")
                                        .padding(.top, 8)

                                    ZStack(alignment: .topLeading) {
                                        // Placeholder
                                        if commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text("Enter your thoughts here")
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 12)
                                                .font(.montserrat(14, weight: .regular))
                                        }

                                        // TextEditor
                                        TextEditor(text: $commentText)
                                            .padding(4)
                                            .background(Color.clear)
                                            .frame(height: 100)
                                            .font(.montserrat(14, weight: .regular))
                                            .foregroundColor(.black)
                                            .scrollContentBackground(.hidden)
                                            .doneToolbar()

                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )



                            // Subject Field
                            Button(action: {
                                navigateToGoalDate = true
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("When do you want archive it?")
                                        .font(.montserrat(12, weight: .semibold))
                                        .foregroundColor(.black)

                                    HStack(spacing: 8) {
                                        Image("date_goal")
                                            .foregroundColor(primaryColor)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(selectedDate)
                                                 .font(.montserrat(14, weight: .regular))
                                                .foregroundColor(.black)

                                            Rectangle()
                                                .fill(primaryColor)
                                                .frame(height: 1)


                                        }
                                        
                                        Spacer()
                                        
                                    }

                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            }

                           
                            
                            Spacer().frame(height: 32)

                            // Send Button
                            Button(action: {
                               saveAddGoal()
                            }) {
                                Text("Add")
                                    .foregroundColor(.white)
                                     .font(.montserrat(16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        (selectedDate == "Select Date" || commentText == "Enter your goal here")
                                        ? Color.gray
                                        : Color(hex: Constants.API.PrimaryColorHex)
                                    )
                                    .cornerRadius(28)

                            }.disabled(commentText == "Enter your goal here" || selectedDate == "Select Date")

                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 0)
                        .padding(.bottom, 100)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    )
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                    
                    
                    NavigationLink(
                        destination: SelectGoalDatePicker(selectedDateString: $selectedDate),
                        isActive: $navigateToGoalDate
                    ) {
                        EmptyView()
                    }

                    
                    navigationLinks()
                }
            }
            .navigationBarBackButtonHidden(true)
            

        }
        
        
        
    }
    
    private func saveAddGoal() {

            do {
               
                let goalData: [String: String] = [
                                           "id": UUID().uuidString,
                                           "goalDescrition": commentText,
                                           "date": selectedDate,
                                          
                                       ]
                GoaldataBaseHelper.sharedGoal.saveGoal(object: goalData)
                txtAddGoal = "yes"
                   
                presentationMode.wrappedValue.dismiss()
               

            } catch {
                print("Meinstein API error: \(error.localizedDescription)")
            }
        }

    
    @ViewBuilder
    func navigationLinks() -> some View {
        
        NavigationLink(
            destination: DashboardView(
                store: Store(
                    initialState: DashboardFeature.State(),
                    reducer: { DashboardFeature() }
                )
            ),
            isActive: $navigateToDashboard
        ) {
            EmptyView()
        }

        NavigationLink(
            destination: PersonaView(
                store: Store(
                    initialState: PersonaFeature.State(),
                    reducer: { PersonaFeature() }
                )
            ),
            isActive: $navigateToPersona
        ) {
            EmptyView()
        }
        
        NavigationLink(
            destination: SettingView(),
            isActive: $navigateToSettings
        ) {
            EmptyView()
        }
  


    }
}


#Preview {
    AddGoalView()
}


