//
//  HealthGoalView.swift
//  mE Health
//
//  Created by Ishant Tiwari on 31/07/25.
//




import SwiftUI
import ComposableArchitecture
import CoreData


var txtAddGoal = ""
var selectedGoalToEdit: HealthCardData? = nil
var goalid = ""


// MARK: - Clinic List View
struct HealthGoalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showOverlay = false
    
    @State private var showSettingScreen = false
    @State private var showAddGoalScreen = false
    @State private var editAddGoalScreen = false
    @State private var isLoading = false
    @State private var isLoadingLoader: Bool = false
    @State private var showDeleteAlert = false
    @State private var showListView = false
    @State private var goalToDelete: HealthCardData? = nil
    @State private var selectedFilters: Set<FilterOption> = [.all]
    @State private var allGoalItems: [HealthCardData] = []
    
    @Dependency(\.assitAdviceClient) var client
    @StateObject private var vitalVM = ReadDataobservation()
    @StateObject private var conditionVM = ReadDatcondition()
    @StateObject private var labVM = ReadDatdiagnostic_report()
    @StateObject private var imagingVM = ReadDatimaging_study()
    @StateObject private var patientVM = ReadDatapatient()
    @StateObject private var claimVM = ReadDatclaim()
    @StateObject private var allergyVM = ReadDataallergyIntolerances()
    @StateObject private var immunizationVM = ReadDataimmunization()
    @StateObject private var encounterVM = ReadDatencounter()
    @StateObject private var medicationVM = ReadDatamedication_request()
    @StateObject private var procedureVM = ReadDataprocedure()

  

    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(txtCondition)
                        .font(.custom("Montserrat-Bold", size: 34))
                        .padding(.horizontal)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            if allGoalItems.isEmpty {
                                NoDataHealthView()
                            } else {
                                ForEach(allGoalItems) { item in
                                    HealthGoalCardView(
                                        health: item,
                                        onTap: {
                                            // Expand goal or open modal
                                        },
                                        onDelete: {
                                            goalToDelete = item
                                            showDeleteAlert = true

                                        },
                                        onEdit: {
                                            goalid = item.id
                                            selectedGoalToEdit = item
                                            txtAddGoal = ""
                                            editAddGoalScreen = true
                                        }
                                    )
                                }
                                
                            }
                       
                        }
                        .padding(.horizontal)
                    }.alert("Are you sure you want to delete this goal?", isPresented: $showDeleteAlert, actions: {
                        Button("Delete", role: .destructive) {
                            if let goal = goalToDelete {
                                txtAddGoal = ""
                                GoaldataBaseHelper.sharedGoal.deleteGoal(by: goal.id)
                                loadGoalData()
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }, message: {
                        Text("This action cannot be undone.")
                    })

               
                    .padding(.top)
                    Button(action: {
                       
                        showAddGoalScreen = true
                    }) {
                        HStack(spacing: 8) {

                            Text("Add a Goal")
                                .font(.montserrat(16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height:45)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(hex: "FF6605"))
                                .cornerRadius(32)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CustomBackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                             Button(action: {
                                 showSettingScreen = true
                                 
                             }) {
                                 Image("setting")
                                     .foregroundColor(Color(hex: "FF6605"))
                             }
                         }
                }
                
                NavigationLink(
                    destination: AddGoalView()
                    ,
                    isActive: $showAddGoalScreen
                ) {
                    EmptyView()
                }

                
                NavigationLink(
                    destination: EditGoalView()
                    ,
                    isActive: $editAddGoalScreen
                ) {
                    EmptyView()
                }
               // navigationLinks()


                // MARK: - Overlay
                if showOverlay {
                    ZStack {
                        // Dimmed Background
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .transition(.opacity)

                        // Centered Modal with padding
                        VStack(spacing: 16) {
                            Text(goalmorecontent)
                            .font(.custom("Montserrat-Semibold", size: 14))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 24)

                            Divider()

                            Button(action: {
                                withAnimation {
                                    isExpanded = false
                                    showOverlay = false
                                }
                            }) {
                                Text("OK")
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 12)
                            }
                        }
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.horizontal, 24) // ✅ This is now applied directly to the card
                        .transition(.scale)
                    }
                    .zIndex(10)
                }

                // ✅ Full-Screen Loader Overlay
                if isLoadingLoader {
                    ZStack {
                        Color.white.opacity(0.8).ignoresSafeArea()

                        LoaderOverlayView(
                                   isVisible: $isLoadingLoader,
                                   showListView: $showListView,
                                   isLoading: $isLoading
                               )
                    }
                    .transition(.opacity)
                    .zIndex(1)

                }

            }
        }.onAppear(){
           // var filtered: [AssistItem] = []
            
           // filtered = getFilteredData()
           // print(filtered)
            loadGoalData()
        }
    }
    func loadGoalData() {
        let context = PersistenceController.shared.goalContext
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            
            let goaldataArray = try context.fetch(request)
                   print(goaldataArray)
                   
                   allGoalItems = goaldataArray.map {
                       HealthCardData(
                           id: $0.id ?? UUID().uuidString,
                           goalDescrition: $0.goalDescrition ?? "",
                           date: $0.date ?? ""
                       )
                   }
            let lastItem = allGoalItems.last
            print(lastItem?.goalDescrition ?? "")
            print(lastItem?.date ?? "")
            if txtAddGoal == "yes" {
            isLoading = true
            showListView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    var filtered: [AssistItem] = []
                    
                    filtered = getFilteredData()
                    print(filtered)
                    var listNames = filtered.map { "\($0.name) : \($0.date)" }.joined(separator: " - ")
                    isLoadingLoader = true
                    if let goalDescription = lastItem?.goalDescrition, let date = lastItem?.date {
                        listNames += " - \(goalDescription) : \(date)"
                    }
                    print(listNames)
                    
                    let firstname = userProfileData?.first_name ?? ""
                    let last_name = userProfileData?.last_name ?? ""
                    let address = userProfileData?.address ?? ""
                    let dob = userProfileData?.dateOfBirth ?? ""
                    
                    if let age = dob.age() {
                        print("Age: \(age)")
                  
                        let promtmsg = "Hi My name is " + firstname + " " + last_name + " and my age " + "\(age)" + " my date of birth is " + dob +  " my address is " + address + " Please  generate " + txtCondition + " advice with basis of my name in meaning full with polite data also provide disclaimer " + listNames
                        print(promtmsg)
                        
                        Task {
                            await generateChatResponse(listNames: promtmsg)
                            }
                    }
                    Task {
                        await generateChatResponse(listNames: listNames)
                        
                    }
                }
            }
        } catch {
            print("Failed to fetch: \(error)")
            self.allGoalItems = []
        }
    }
    
    private func generateChatResponse(listNames: String) async {

        do {
            let response = try await client.callMeinsteinAPI(listNames)

            if let assistantMessage = response.choices.first?.message {

                let msg: [String: String] = [
                                       "title": txtCondition,
                                       "content": assistantMessage.content,
                                       "date": Date().toString(),
                                       "role": assistantMessage.role,
                                       "fav": "0",
                                       "ignore": "0",
                                       "review": "0",
                                       "read": "0",
                                       "unread": "0"
                                   ]
                DataBaseHelper.shared.save(object: msg)
               
                
            } else {
                print("No message returned from Meinstein response.")
            }

        } catch {
            print("Meinstein API error: \(error.localizedDescription)")
        }
    }
    
    
    
    private func getFilteredData() -> [AssistItem] {
        let vitals = vitalVM.vitalArray as [AssistItem]
        let conditions = conditionVM.conditionArray as [AssistItem]
        let labs = labVM.labs as [AssistItem]
        let imagingArr = imagingVM.imagingarray as [AssistItem]
        let patientArr = patientVM.patient as [AssistItem]
        let claimArr = claimVM.claim as [AssistItem]
       
        let allergyArr = allergyVM.allergy as [AssistItem]
       
        let immunizationVMArr = immunizationVM.immune as [AssistItem]
       
        let encounterVMArr = encounterVM.visitData as [AssistItem]
       
        let medicationVMArr = medicationVM.medication as [AssistItem]
        return vitals + conditions + labs + imagingArr + patientArr + claimArr + medicationVMArr


       
    }
    


}

#Preview {
    HealthGoalView()
}
