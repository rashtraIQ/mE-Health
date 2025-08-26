//
//  AssistDetailView.swift
//  mE Health
//
//  Created by Rashida on 26/06/25.
//

import SwiftUI
import ComposableArchitecture
import Foundation
import Combine

var getPromt = ""


var getPromtTitleMsg = ""
var getPromtTitleTask = ""





struct AssistDetailView: View {

    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    @State private var isLoading = false
    @State private var showListView = false
    @Environment(\.presentationMode) var presentationMode

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
    @StateObject private var appoinmentVM = ReadDataappointment()

  
    
   
    
    @State private var filteredList: [AssistItem] = []
    
    @Dependency(\.assitAdviceClient) var client
    @State private var isLoadingLoader: Bool = false
    @State private var chatMessages: [ChatMessage] = []
    
    @State private var isLoadingOverlayVisible = false


    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {

                Text(txtCondition)
                     .font(.montserrat(16, weight: .semibold))

                // MARK: - Date Pickers
                HStack(spacing: 12) {
                    // Start Date Picker
                    Button {
                        isStartDatePickerPresented = true
                    } label: {
                        DateCardView(title: "Start Date", date: formattedDate(startDate))
                    }
                    .sheet(isPresented: $isStartDatePickerPresented) {
                        DatePickerModalView(
                            title: "Start Date",
                            isPresented: $isStartDatePickerPresented,
                            selectedDate: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                            ),
                            minimumDate: nil
                        )
                    }

                    // End Date Picker
                    Button {
                        if startDate != nil {
                            isEndDatePickerPresented = true
                        }
                    } label: {
                        DateCardView(title: "End Date", date: formattedDate(endDate))
                    }
                    .disabled(startDate == nil)
                    .opacity(startDate == nil ? 0.5 : 1.0)
                    .sheet(isPresented: $isEndDatePickerPresented) {
                        if let safeStart = startDate {
                            DatePickerModalView(
                                title: "End Date",
                                isPresented: $isEndDatePickerPresented,
                                selectedDate: Binding(
                                    get: { endDate ?? safeStart },
                                    set: {
                                        if $0 >= safeStart {
                                            endDate = $0
                                            showListView = false
                                            filteredList = []
                                        }
                                    }
                                ),
                                minimumDate: safeStart
                            )
                        }
                    }
                }

                // MARK: - Apply Button
                if !showListView {
                    Button {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         
                            var filtered: [AssistItem] = []
//                            switch txtCondition {
//                            case "Behavioral Health Risk Estimator":
//                                filtered = getFilteredData()
//
//                            case "Chronic Condition Detector":
//                                filtered = getFilteredData()
//
//                            case "Gaps in Care Identifier":
//                                filtered = getFilteredData()
//
//                            case "Polypharmacy Risk Detector":
//                                filtered = getFilteredData()
//
//                            case "Medication Adherence Risk Predictor":
//                                filtered = getFilteredData()
//
//                            case "Preventive Care Advisor":
//                                filtered = getFilteredData()
//
//                            case "Social Determinants of Health (SDoH) Estimator":
//                                filtered = getFilteredData()
//
//                            case "Imaging Based Condition Validator":
//                                filtered = getFilteredData()
//
//                            case "Imaging Trend Analyzer":
//                                filtered = getFilteredData()
//
//                            default:
//                                break
//                            }
                            filtered = getFilteredData()
                      
                            guard !filtered.isEmpty else {
                                isLoading = false
                                return
                            }
                           
                            filteredList = filtered
                            isLoadingLoader = true

                            let listNames = filtered.map { "\($0.name) : \($0.date)" }.joined(separator: " - ")
                            print(listNames)
                            
                            let firstname = userProfileData?.first_name ?? ""
                            let last_name = userProfileData?.last_name ?? ""
                            
                            let address = userProfileData?.address ?? ""
                            
                            
                            
                            
                            let dob = userProfileData?.dateOfBirth ?? ""
                            if let age = dob.age() {
                                print("Age: \(age)")
                          
//                                let promtmsg = "Hi My name is " + firstname + " " + last_name + " and my age " + "\(age)" + " my date of birth is " + dob +  " my address is " + address + " Please  generate " + txtCondition + " professional advice with basis of my name in meaning full with polite data also provide disclaimer " + listNames
                                
                                let promtmsg = getPromt + listNames
                                print(promtmsg)
                                
                                print(getPromt)
                                
                                Task {
                                    await generateChatResponse(listNames:getPromt)

                                    }
                            }
                            else {
                                
                            }
                            
  
                        }
                    } label: {
                        Text("Apply")
                            .font(.montserrat(17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isApplyEnabled ? Color(hex: Constants.API.PrimaryColorHex) : Color(hex: "AAAEB3"))
                            .foregroundColor(.white)
                            .cornerRadius(32)
                    }
                    .disabled(!isApplyEnabled || isLoading)
                    .padding(.top, 20)
                }
                
                if startDate == nil || endDate == nil || filteredList.isEmpty {
                    NoDataView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top,0)
                } else {
                    
                    // MARK: - Filtered List
                    if showListView {
                        List(filteredList, id: \.id) { item in
                            AssistListCardView(assistData: item.toAssistListData()) {
                                print("Tapped item with ID: \(item.id)")
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 2)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .background(Color.white)

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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomBackButton {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }


    private var isApplyEnabled: Bool {
        startDate != nil && endDate != nil
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "MM-DD-YYYY" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private static func parseJSON(_ jsonString: String?) -> [String: Any]? {
        guard let jsonString, let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return json
    }
    

    private func getFilteredData() -> [AssistItem] {
              
                                    switch txtCondition {
                                    case "Behavioral Health Risk Estimator":
                                      getPromtTitleMsg = getPromtTitleBehavior
                                       getPromtTitleTask = getPromtTaskBehavior
        
                                    case "Chronic Condition Detector":
                                        getPromtTitleMsg = getPromtTitleChoronic
                                         getPromtTitleTask = getPromtTaskChoronic
        
                                    case "Gaps in Care Identifier":
                                        getPromtTitleMsg = getPromtTitleGaps
                                         getPromtTitleTask = getPromtTaskGaps
        
                                    case "Polypharmacy Risk Detector":
                                        getPromtTitleMsg = getPromtTitlePolypharmacy
                                         getPromtTitleTask = getPromtTaskPolypharmacy
        
                                    case "Medication Adherence Risk Predictor":
                                        getPromtTitleMsg = ""
                                         getPromtTitleTask = ""
        
                                    case "Preventive Care Advisor":
                                        getPromtTitleMsg = ""
                                         getPromtTitleTask = ""
        
                                    case "Social Determinants of Health (SDoH) Estimator":
                                        getPromtTitleMsg = ""
                                         getPromtTitleTask = ""
        
                                    case "Imaging Based Condition Validator":
                                        getPromtTitleMsg = ""
                                         getPromtTitleTask = ""
        
                                    case "Imaging Trend Analyzer":
                                        getPromtTitleMsg = ""
                                         getPromtTitleTask = ""
        
                                    default:
                                        break
                                    }
        
        let vitals = vitalVM.vitalArray as [AssistItem]
        print(vitals)
        let conditions = conditionVM.conditionArray as [AssistItem]
        print(conditions)
        let labs = labVM.labs as [AssistItem]
        print(labs)
        let imagingArr = imagingVM.imagingarray as [AssistItem]
        print(imagingArr)
        let procedureVMArr = procedureVM.procedures as [AssistItem]
        print(procedureVMArr)
        let appoinmentArr = appoinmentVM.appoitments as [AssistItem]
        print(appoinmentArr)
        let allergyArr = allergyVM.allergy as [AssistItem]
        print(allergyArr)
        let immunizationVMArr = immunizationVM.immune as [AssistItem]
        print(allergyArr)
        let encounterVMArr = encounterVM.visitData as [AssistItem]
        print(encounterVMArr)
        let medicationVMArr = medicationVM.medication as [AssistItem]
        print(medicationVMArr)
        
        let firstname = userProfileData?.first_name ?? ""
        let last_name = userProfileData?.last_name ?? ""
        
        let address = userProfileData?.address ?? ""
        
        let dob = userProfileData?.dateOfBirth ?? ""
        let age = dob.age()
       print("Age: \(String(describing: age))")
      
       let currentYear = Calendar.current.component(.year, from: Date())
        
       
        
       

        var prompt = getPromtTitleMsg
        

       if let patient = userProfileData {
           prompt += "- Age: \(String(describing: age!)), Gender: \(userProfileData?.gender ?? "Unknown"), Birth Date: \(String(describing: userProfileData?.dateOfBirth ?? ""))\n"
           prompt += "- Address: \(userProfileData?.address ?? ""), \(userProfileData?.city ?? ""), \(userProfileData?.state ?? "") \(userProfileData?.zipCode ?? "")\n"
       }
        print(prompt)
       prompt += "\n**Known Conditions**:\n"
       for condition in conditions {
                let code = condition.name
                let status = condition.assitStatus
               let onset = condition.date  // Or parse into Date for formatting
                prompt += "- \(code), Status: \(status), Date: \(onset)\n"
            }
        print(prompt)
        prompt += "\n**Vitals**:\n"
        for vital in vitals {

            
            let code = vital.name
            let status = vital.assitStatus
            // Or parse into Date for formatting
            let date = vital.date
            prompt += "- \(code ): \(status), Date: \(date)\n"
        }
        print(prompt)
        prompt += "\n**Medications**:\n"
        for med in medicationVMArr {
            let code = med.name
            let date = med.date
            let status = med.assitStatus
            //Or parse into Date for formatting
            prompt += "- \(code), Status: \(status), Authored: \(date), Reason: \(code)\n"
        }
        print(prompt)
        prompt += "\n**Allergies**:\n"
        for allergy in allergyArr {
            let code = allergy.name
            let status = allergy.assitStatus
            let date = allergy.date
            prompt += "- \(code), Status: \(status), Recorded: \(date)\n"
        }
        print(prompt)
        prompt += "\n**Lab Results**:\n"
        for lab in labs {
            let code = lab.name
            let status = lab.assitStatus
            let datePerformer = lab.dateRange
            let date = lab.date
            prompt += "- \(code), Date: \(date), Performer: \(datePerformer)\n"
        }
        print(prompt)
        prompt += "\n**Procedures**:\n"
        for proc in procedureVMArr {
            let code = proc.name
            let reason = proc.assitStatus
            // Or parse into Date for formatting
            prompt += "- \(code), Status: \(proc.assitStatus), Performed: \(proc.date), Reason: \(reason)\n"
        }
        print(prompt)
        prompt += "\n**Imaging Studies**:\n"
        for study in imagingArr {
            let code = study.name
            let status = study.dateRange
            // Or parse into Date for formatting
            prompt += "- Study: \(code), Modality: \(study.name), Date: \(study.date), Reason: \(""), Note: \("")\n"
        }
        print(prompt)
        prompt += "\n**Appointments**:\n"
        for appt in appoinmentArr {
            let code = appt.name
            let status = appt.assitStatus
            // Or parse into Date for formatting
            prompt += "- \(code), Reason: \("")\n, Date: \(appt.date)\n"
        }
        print(prompt)
        prompt += "\n**Immunizations**:\n"
        for imm in immunizationVMArr {
            let code = imm.name
            let status = imm.date
            // Or parse into Date for formatting
            prompt += "- \(code), Date: \(status)\n"
        }
        print(prompt)
        prompt += "\n**Encounters**:\n"
        for enc in encounterVMArr {
            let code = enc.name
            let status = enc.assitStatus
            // Or parse into Date for formatting
            prompt += "- Encounter: \(""), Status: \(enc.assitStatus ?? ""), Start: \(enc.date)\n"
        }
        print(prompt)

       prompt += getPromtTitleTask
      
       print(prompt)
        
        getPromt = prompt
        
        print(getPromt)
        
        

        return (vitals + conditions + labs + imagingArr + allergyArr + immunizationVMArr + encounterVMArr + medicationVMArr)
            .filter { item in
                if let start = startDate, let end = endDate {
                    return item.date >= start && item.date <= end
                }
                return false
            }
            .sorted { $0.date > $1.date }
    }
    
   
    
    private func generateChatResponse(listNames: String) async {

        do {
            let response = try await client.callMeinsteinAPI(listNames)
            print(response)
            

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
    
    private func saveMessagesToUserDefaults(_ messages: [ChatMessage]) {
        let defaults = UserDefaults.standard
        do {
            let data = try JSONEncoder().encode(messages)
            defaults.set(data, forKey: "chatMessages")
        } catch {
            print("Failed to encode messages: \(error)")
        }
    }
    

}

struct ChatResponse: Codable {
    let id: String
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let index: Int
}

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatMessage: Codable {
    let role: String
    let content: String
    let title: String
    let date: String
    let fav: String
    let ignore: String
    let review: String
    let read: String
    let unread: String
}

struct RequestBody: Codable {
    let messages: [Message]
    let temperature: Double
}

var dateRange = ""
var startyear  = ""
var assitstartDate: Date? = nil

var chatMessages: [ChatMessage] = []


protocol AssistItem: Identifiable {
    var id: String { get }
    var date: Date { get }
    var categoryName: String { get }
    var assitStatus: String { get }
    var time: String { get }
    var name: String { get }
    var dateRange: String { get }
    func toAssistListData() -> AssistListData
}

extension AssistItem {
    func toAssistListData() -> AssistListData {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let timeString = formatter.string(from: self.date)
        
        return AssistListData(
            dateRange: formattedRange(),
            category: self.categoryName,
            time: timeString,
            name: self.categoryName // You can customize this further
        )
    }
    
    private func formattedRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self.date)
        return "\(year) - \(year)"
    }
}

extension VitalDummyData: AssistItem {
    
    var assitStatus: String {
        status
    }

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }

    var categoryName: String {
        "Vital"
    }

    var name: String {
        codeDisplay
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension ConditionDummyData: AssistItem {
    var assitStatus: String {
        clinicalStatus
    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: onsetDate) ?? Date.distantPast
    }

    var categoryName: String {
        "Condition"
    }
    
   

    var name: String {
        codeDisplay
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension LabDummyData: AssistItem {
    
    var assitStatus: String {
        status
    }

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "Labs"
    }
    var name: String {
        codeDisplay
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension ImagingDummyData: AssistItem {
    
    var assitStatus: String {
        reasonCodeDisplay
    }

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "Imaging"
    }
    var name: String {
        "\(modalityDisplay) \(modalityCode)"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension PatientDummyData: AssistItem {
    var assitStatus: String {
      name
    }
    
    
   

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "Patient"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension ProcedureDummyData: AssistItem {
    var assitStatus: String {
        rawReasonCode
    }
    
    var name: String {
        "\(codeDisplay)"

    }
    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }

   
    var categoryName: String {
        "procedures"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension BillingItem: AssistItem {
    
    var assitStatus: String {
        claimId
    }
    var name: String {
        "\(insurance?.coverage.display ?? "")"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "claims"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension AllergyData: AssistItem {
    
    var assitStatus: String {
        clinicalStatus
    }
    var name: String {
        "\(code?.display ?? "")"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "allergyIntolerances"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension ImmuneDummyData: AssistItem {
    
    var assitStatus: String {
        rawVaccineCode
    }
    var name: String {
        "\(vaccineCodeDisplay)"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "immunizations"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension VisitDummyData: AssistItem {
    
    var assitStatus: String {
        description
    }
    var name: String {
        "\(description)"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "encounters"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension MedicationDummyData: AssistItem {
    
    var assitStatus: String {
        status
    }
    
    var name: String {
        "\(medicationCodeCode)"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: authoredOn) ?? Date.distantPast
    }
    var categoryName: String {
        "medicationRequests"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}

extension AppointmentData: AssistItem {
    
    var assitStatus: String {
        practitionerName
    }
    
    var name: String {
        "\(description)"

    }
    

    var date: Date {
        ISO8601DateFormatter().date(from: createdAt) ?? Date.distantPast
    }
    var categoryName: String {
        "appointments"
    }
    
    var time: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func toAssistListData() -> AssistListData {
        AssistListData(
            dateRange: dateRange,
            category: categoryName,
            time: time,
            name: name
        )
    }
}





struct LoaderOverlayView: View {
    @Binding var isVisible: Bool
    @Binding var showListView: Bool
    @Binding var isLoading: Bool

    @State private var loadingTextIndex = 0
    @State private var timer: Timer?

    let loadingTexts = [
        "Pulling up your health timeline,\njust a heartbeat away.........",
        "We’re flipping through your\nmedical diary…......",
        "Measuring, matching, and making\nsense of it all..........",
        "Health data is crucial.\nLuckily, we’ve got it covered......",
        "Loading insights, your advice is on\nits way! Stay with us........"
    ]

    var body: some View {
        GeometryReader { geometry in
            if isVisible {
                VStack(spacing: 16) {
                    LottieView(name: "loader_animation", loopMode: .loop)
                        .frame(width: 60, height: 60)

                    Text(loadingTexts[loadingTextIndex])
                       .font(.montserrat(12, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .animation(.easeInOut, value: loadingTextIndex)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(width: min(geometry.size.width * 0.8, 320))
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 8)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Centered
                .onAppear {
                    startLoaderTimer()
                }
                .onDisappear {
                    stopLoaderTimer()
                }
            }
        }

    }

    private func startLoaderTimer() {
        loadingTextIndex = 0
        var step = 1

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if step < loadingTexts.count {
                loadingTextIndex = step
                step += 1
            } else {
                stopLoaderTimer()
                // Final delay for user to read last message
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isVisible = false
                    showListView = true
                    isLoading = false
                }
            }
        }
    }

    private func stopLoaderTimer() {
        timer?.invalidate()
        timer = nil
    }
}
//private func getFilteredDatasdoh() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let vitalArr = vitalVM.vitalArray as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + vitalArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDataPrevintive() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let immunizationArr = immunizationVM.immune as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + immunizationArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//
//
//private func getFilteredDataPolypharmacy() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let medicationArr = medicationVM.medication as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + medicationArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//
//private func getFilteredDataMedication() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let medicationArr = medicationVM.medication as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + medicationArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDataImagineTrend() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let procedureArr = procedureVM.procedures as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + procedureArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDataImagineBased() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let procedureArr = procedureVM.procedures as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + procedureArr + encounterVMArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDataGaps() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let procedureArr = procedureVM.procedures as [AssistItem]
//    let vitalArr = vitalVM.vitalArray as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//   
//    
//
//    return (imagingArr + conditions + procedureArr + vitalArr + patientArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDataChronic() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let vitals = vitalVM.vitalArray as [AssistItem]
//    let labsArr = labVM.labs as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//    
//
//    return (imagingArr + vitals + labsArr + patientArr + encounterVMArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
//
//private func getFilteredDatBehaviour() -> [AssistItem] {
//    let imagingArr = imagingVM.imagingarray as [AssistItem]
//    let vitals = vitalVM.vitalArray as [AssistItem]
//    let conditions = conditionVM.conditionArray as [AssistItem]
//    let patientArr = patientVM.patient as [AssistItem]
//    let encounterVMArr = encounterVM.visitData as [AssistItem]
//  
//  
//    
//
//    return (imagingArr + vitals + conditions + patientArr + encounterVMArr)
//        .filter { item in
//            if let start = startDate, let end = endDate {
//                return item.date >= start && item.date <= end
//            }
//            return false
//        }
//        .sorted { $0.date > $1.date }
//}
