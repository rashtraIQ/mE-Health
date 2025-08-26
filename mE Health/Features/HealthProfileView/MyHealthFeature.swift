//
//  MyHealthFeature.swift
//  mE Health
//
//  Created by Ishant on 16/06/25.
//

import ComposableArchitecture
import SwiftUI

struct Tile: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    
}


struct MyHealthFeature: Reducer {
    
    struct State: Equatable {
        
        var tiles: [Tile] = [
            Tile(title: "Practitioners", icon: "practioner"),
            Tile(title: "Appointments", icon: "appoinment"),
            Tile(title: "Visits", icon: "Visits"),
            Tile(title: "Conditions", icon: "conditions"),
            Tile(title: "Labs", icon: "Labs"),
            Tile(title: "Vitals", icon: "vitals"),
            Tile(title: "Medications", icon: "Savings"),
            Tile(title: "Imaging", icon: "Imaging"),
            Tile(title: "Procedures", icon: "Procedures"),
            Tile(title: "Allergies", icon: "Allergy"),
            Tile(title: "Immunizations", icon: "Immunization"),
            Tile(title: "Billing", icon: "Billing"),
            Tile(title: "Records Vault", icon: "Upload"),
        ]
        var selectedIndex: Int = 0
        var selectedPractitioner: PractitionerData? = nil
        var selelctedAllergy: AllergyData? = nil
        var selectedLab: LabDummyData? = nil
        var header: HeaderFeature.State = .init()
        var selelctedApooitment: AppointmentData? = nil
        var selctedProcedure: ProcedureDummyData? = nil
        var selctedVital: VitalDummyData? = nil
        var selectImune: ImmuneDummyData? = nil
        var selectMed : MedicationDummyData? = nil
        var selectVisit : VisitDummyData? = nil
        var selectBilling : BillingItem? = nil
        var selectCondition : ConditionDummyData? = nil
        var selectImaging : ImagingDummyData? = nil
        
    }

    enum Action: Equatable {
        case backButtonTapped
        case selectTile(Int)
        case practitionerTapped(PractitionerData)
        case dismissPractitionerDetail
        case allergyTapped(AllergyData)
        case dismissAllergyDetail
        case header(HeaderFeature.Action)
        case openLabDetail(LabDummyData)
        case closeLabDetail
        
        case openApoitmentDetial(AppointmentData)
        case closeApoitmentDetial
        
        case openProcedureDetail(ProcedureDummyData)
        case closeProcedureDEtail
        
        case openVitalDetail(VitalDummyData)
        case closeVitalDEtail

        case openImmuneDetail(ImmuneDummyData)
        case closeImmuneDetail
        
        case openMedDetail(MedicationDummyData)
        case closeMedDetail

        case openVisitsDetail(VisitDummyData)
        case closeVisitDetail
        
        case openBillingDetail(BillingItem)
        case closeBillingDetail
        
        case openConditionDetail(ConditionDummyData)
        case closeConditionDetail
        
        case openImagingDetail(ImagingDummyData)
        case closeImagingDetail

    }

    var body: some ReducerOf<Self> {
        
        Scope(state: \.header, action: /Action.header) {
               HeaderFeature()
           }

        Reduce { state, action in
            switch action {
                
            case .backButtonTapped:
                return .none
                
            case .selectTile(let index):
                state.selectedIndex = index
                let selectedTitle = state.tiles[index].title
                let title = selectedTitle == "Records Vault" ? "Files" : selectedTitle
                state.header.title = "List of \(title)"
                state.header.categoryName = title
                state.header.availableFilters = filtersForCategory(title)
                state.header.selectedFilters = [] // clear filters when tile changes
                return .none
                
            case .practitionerTapped(let practitioner):
                state.selectedPractitioner = practitioner
                return .none

            case .dismissPractitionerDetail:
                state.selectedPractitioner = nil
                return .none

            case .allergyTapped(let allergy):
                state.selelctedAllergy = allergy
                return .none
                
            case .dismissAllergyDetail:
                state.selelctedAllergy = nil
                return .none
                
            case .openLabDetail(let lab):
                state.selectedLab = lab
                return .none
                
            case .closeLabDetail:
                state.selectedLab = nil
                return .none
                
            case .openApoitmentDetial(let appoitment):
                state.selelctedApooitment = appoitment
                return .none
                
            case .closeApoitmentDetial:
                state.selelctedApooitment = nil
                return .none
                
                
            case .openProcedureDetail(let data):
                state.selctedProcedure = data
                return .none
                
            case .closeProcedureDEtail:
                state.selctedProcedure = nil
                return .none
                
                
            case .openVitalDetail(let data):
                state.selctedVital = data
                return .none

                
            case .closeVitalDEtail:
                state.selctedVital = nil
                return .none
                
            case .openImmuneDetail(let data):
                state.selectImune = data
                return .none

                
            case .closeImmuneDetail:
                state.selectImune = nil
                return .none
                
                
            case .openMedDetail(let data):
                state.selectMed = data
                return .none

                
            case .closeMedDetail:
                state.selectMed = nil
                return .none
                

            case .openVisitsDetail(let data):
                state.selectVisit = data
                return .none
                
            case .closeVisitDetail:
                state.selectVisit = nil
                return .none
                
            case .openBillingDetail(let data):
                state.selectBilling = data
                return .none
                
            case .closeBillingDetail:
                state.selectBilling = nil
                return .none

            case .openConditionDetail(let data):
                state.selectCondition = data
                return .none
                
            case .closeConditionDetail:
                state.selectCondition = nil
                return .none

                
            case .openImagingDetail(let data):
                state.selectImaging = data
                return .none

                
            case .closeImagingDetail:
                state.selectImaging = nil
                return .none


            case .header:
                return .none

            }
        }
    }
    
    func filtersForCategory(_ name: String) -> [FilterType] {
        switch name {
        case "Appointments":
            return [
                .all,
                FilterType(label: "Fulfilled"),
                FilterType(label: "Booked")
            ]
        case "Visits":
            return [
                .all,
                FilterType(label: "Finished"),
                FilterType(label: "Planned")
            ]
        case "Conditions":
            return [
                .all,
                FilterType(label: "Active"),
                FilterType(label: "Resolved")
            ]
        case "Labs":
            return [
                .all,
                FilterType(label: "Final"),
                FilterType(label: "Preliminary")
            ]

        case "Vitals":
            return [ .all,
                     FilterType(label: "Final")
            ]
                
        case "Medications":
            return [ .all,
                     FilterType(label: "Active"),
                     FilterType(label: "Completed")
            ]
            
        case "Imaging":
            return [ .all,
                     FilterType(label: "Final")
            ]
            
        case "Procedures":
            return [ .all,
                     FilterType(label: "Completed")
            ]
            
        case "Allergies":
            return [ .all,
                     FilterType(label: "Clinical Status"),
                     FilterType(label: "Active")
            ]

        case "Immunizations":
            return [ .all,
                FilterType(label: "Completed")
            ]

        case "Billing":
            return [ .all,
                     FilterType(label: "Active")
            ]
            
        case "Files":
            return [ .all,
                     FilterType(label: "Practitioners"),
                     FilterType(label: "Appointments"),
                     FilterType(label: "Visits"),
                     FilterType(label: "Conditions"),
                     FilterType(label: "Labs"),
                     FilterType(label: "Vitals"),
                     FilterType(label: "Medications"),
                     FilterType(label: "Imaging"),
                     FilterType(label: "Procedures"),
                     FilterType(label: "Allergies"),
                     FilterType(label: "Immunizations"),
                     FilterType(label: "Billing")
            ]

        default:
            return [ .all ]
        }
    }

}


