//
//  LocalJson.swift
//  mE Health
//
//  Created by Ishant Tiwari on 01/07/25.
//

import Foundation

class ReadDatapractitioner: ObservableObject  {
   
    @Published var practitioners: [PractitionerData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "practitioner", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(PractitionerResponse.self, from: data)
            DispatchQueue.main.async {
                self.practitioners = decodedResponse.practitioners
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

class ReadDataappointment: ObservableObject  {
   
    @Published var appoitments: [AppointmentData] = []

    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "appointment", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(AppointmentResponse.self, from: data)
            DispatchQueue.main.async {
                self.appoitments = decodedResponse.appointments
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
    }
     
}




class ReadDatdiagnostic_report: ObservableObject  {
   
    @Published var labs: [LabDummyData] = []

    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "diagnostic_report", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(DiagnosticReportResponse.self, from: data)
            DispatchQueue.main.async {
                self.labs = decodedResponse.diagnosticReports
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}


class ReadDatclaim: ObservableObject  {
    
    @Published var claim: [BillingItem] = []

    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "claim", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ClaimResponse.self, from: data)
            DispatchQueue.main.async {
                self.claim = decodedResponse.claims
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}


class ReadDatcondition: ObservableObject  {
   
    
    @Published var conditionArray: [ConditionDummyData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "condition", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
       
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ConditionResponse.self, from: data)
            DispatchQueue.main.async {
                self.conditionArray = decodedResponse.conditions
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}

class ReadDatimaging_study: ObservableObject  {
   
    @Published var imagingarray: [ImagingDummyData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "imaging_study", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ImagingStudyResponse.self, from: data)
            DispatchQueue.main.async {
                self.imagingarray = decodedResponse.imagingStudies
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

class ReadDataprocedure: ObservableObject  {
   
    @Published var procedures: [ProcedureDummyData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "procedure", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ProcedureJsonResponse.self, from: data)
            DispatchQueue.main.async {
                self.procedures = decodedResponse.procedures
                print(self.procedures)
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}

class ReadDataallergyIntolerances: ObservableObject  {
   
    @Published var allergy: [AllergyData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "allergy_intolerance", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(AllergyResponse.self, from: data)
            DispatchQueue.main.async {
                self.allergy = decodedResponse.allergyIntolerances
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}




class ReadDataobservation: ObservableObject  {
   
    @Published var vitalArray: [VitalDummyData] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "observation", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ObservationResponse.self, from: data)
            DispatchQueue.main.async {
                self.vitalArray = decodedResponse.observations
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
       
        
    }
     
}

class ReadDataimmunization: ObservableObject  {
   
    @Published var immune: [ImmuneDummyData] = []
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "immunization", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(ImmuneResponse.self, from: data)
            DispatchQueue.main.async {
                self.immune = decodedResponse.immunizations
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
     
}


class ReadDatencounter: ObservableObject  {
   
    @Published var visitData: [VisitDummyData] = []
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "encounter", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
       
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(EncounterResponse.self, from: data)
            DispatchQueue.main.async {
                self.visitData = decodedResponse.encounters
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

        
    }
     
}




class ReadDatamedication_request: ObservableObject  {
   
    
    @Published var medication: [MedicationDummyData] = []
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "medication_request", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        print(data!)
       
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(MedicationRequestResponse.self, from: data)
            DispatchQueue.main.async {
                self.medication = decodedResponse.medicationRequests
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

        
    }
     
}





class ReadDatapatient: ObservableObject  {
   
    @Published var patient: [PatientDummyData] = []
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "patient", withExtension: "json")
            else {
                print("Json file not found")
                return
            }

        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(PatientResponse.self, from: data)
            DispatchQueue.main.async {
                self.patient = decodedResponse.patients
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

       
        
    }
     
}


class ReadDatapractitioner_organization: ObservableObject  {
   
    @Published var organizations: [PractitionerOrganization] = []
    
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "practitioner_organization", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        print(data!)
        
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(PractitionerOrganisationResponse.self, from: data)
            DispatchQueue.main.async {
                self.organizations = decodedResponse.practitionerOrganizations
                print(self.organizations)
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

       
        
    }
     
}

class ReadDataorganization: ObservableObject  {
    @Published var organizations: [Organization] = []
      
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "organization", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(OrganisationResponse.self, from: data)
            DispatchQueue.main.async {
                self.organizations = decodedResponse.organizations
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
    }
     
}
