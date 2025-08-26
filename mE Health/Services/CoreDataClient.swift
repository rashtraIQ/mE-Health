
import ComposableArchitecture

struct CoreDataClient {
    var saveResourceTree: (MedicationModel) throws -> Void
    var savePatient: (PatientModel) throws -> Void
    var savePractitioner: (Practitioner) throws -> Void
    var saveResource: (CommonResource) throws -> Void
    var saveConditionModel: (ConditionModel) throws -> Void
    var saveConsentModel: (ConsentModel) throws -> Void
    var saveAppoitmentModel: (AppoitmentModel) throws -> Void
    var saveAllergyModel: (AllergyData) throws -> Void
}

enum CoreDataError: Error {
    case saveFailed
}

extension DependencyValues {
    var coreDataClient: CoreDataClient {
        get { self[CoreDataClientKey.self] }
        set { self[CoreDataClientKey.self] = newValue }
    }
}

private enum CoreDataClientKey: DependencyKey {
    static let liveValue: CoreDataClient = .live
}

extension CoreDataClient {
    static let live = CoreDataClient(
        
        saveResourceTree: { medicationModel in
            let context = PersistenceController.shared.context
            let resourceEntity = ResourceEntity(context: context)

            let resource = medicationModel.entry?.first?.resource
            
            resourceEntity.id = resource?.Id ?? ""
            resourceEntity.resourceType = resource?.resourceType
            resourceEntity.status = resource?.status
            resourceEntity.active = resource?.active ?? false

            // 🔹 Practitioner
            if let practitioner = resource?.practitioner {
                let practitionerEntity = PractitionerEntity(context: context)
                practitionerEntity.id = practitioner.id
//                practitionerEntity.display = practitioner.display
//                practitionerEntity.reference = practitioner.reference
            }

            // 🔹 Identifiers
            if let identifiers = resource?.identifier {
                for identifier in identifiers {
                    let identifierEntity = IdentifierEntity(context: context)
                    identifierEntity.use = identifier.use
                    identifierEntity.value = identifier.value
                    identifierEntity.system = identifier.system
                    resourceEntity.addToIdentifiers(identifierEntity)
                }
            }

            // 🔹 MedicationReference
            if let medication = resource?.medicationReference {
                let medEntity = MedicationReferenceEntity(context: context)
                medEntity.reference = medication.reference
                medEntity.display = medication.display
                resourceEntity.medicationReference = medEntity
            }

            // 🔹 Subject
            if let subject = resource?.subject {
                let subjectEntity = MedicationReferenceEntity(context: context)
                subjectEntity.reference = subject.reference
                subjectEntity.display = subject.display
                resourceEntity.subject = subjectEntity
            }

            // 🔹 Encounter
            if let encounter = resource?.encounter {
                let encounterEntity = EncounterEntity(context: context)
                encounterEntity.reference = encounter.reference
                encounterEntity.display = encounter.display
                resourceEntity.encounter = encounterEntity
            }

            // 🔹 Requester
            if let requester = resource?.requester {
                let requesterEntity = RequesterEntity(context: context)
                requesterEntity.display = requester.display
                requesterEntity.reference = requester.reference
                resourceEntity.requester = requesterEntity
            }

            // 🔹 Dosage Instructions
            if let dosages = resource?.dosageInstruction {
                for dosage in dosages {
                    let dosageEntity = DosageInstructionEntity(context: context)
                    dosageEntity.text = dosage.text
                    resourceEntity.addToDosageInstructions(dosageEntity)
                }
            }

            // 🔹 DispenseRequest
            if let dispense = resource?.dispenseRequest {
                let dispenseEntity = DispenseRequestEntity(context: context)
                dispenseEntity.numberOfRepeatsAllowed = Int16(dispense.numberOfRepeatsAllowed ?? 0)
                resourceEntity.dispenseRequest = dispenseEntity
            }

            do {
                try context.save()
                print("✅ All nested Resource data saved")
            } catch {
                print("❌ Saving resource tree failed: \(error)")
                throw CoreDataError.saveFailed
            }
        },

        savePatient: { patient in
            let context = PersistenceController.shared.context
            let entity = PatientEntity(context: context)
            entity.id = patient.id ?? "1"
         //   entity.name = (patient.name?.first?.given?.joined(separator: " ") ?? "") + " " + (patient.name?.first?.family ?? "")
            entity.gender = patient.gender ?? ""
            entity.birthDate = patient.birthDate ?? ""
            do {
                try context.save()
                print("✅ Saved patient to Core Data")
            } catch {
                print("❌ Core Data save failed: \(error)")
                throw CoreDataError.saveFailed
            }
        },
        savePractitioner: { practitioner in
            let context = PersistenceController.shared.context
            let entity = PractitionerEntity(context: context)
            entity.id = practitioner.id
//            entity.reference = practitioner.reference
//            entity.display = practitioner.display

            do {
                try context.save()
                print("✅ Saved practitioner to Core Data")
            } catch {
                print("❌ Core Data save failed: \(error)")
                throw CoreDataError.saveFailed
            }
        },

        saveResource: { resource in
            let context = PersistenceController.shared.context
            let entity = ResourceEntity(context: context)
            entity.id = ""
            entity.resourceType = resource.resourceType
            entity.status = ""
            entity.active = false
            
            // Save nested practitioner
//            if let practitioner = resource.practitioner {
//                let practitionerEntity = PractitionerEntity(context: context)
//                practitionerEntity.id = practitioner.id
////                practitionerEntity.display = practitioner.display
////                practitionerEntity.reference = practitioner.reference
//                //entity.practitioner = practitionerEntity
//            }
            
            // Save identifier array
//            if let identifiers = resource.identifier {
//                let identifierEntities = identifiers.map { identifier -> IdentifierEntity in
//                    let idEntity = IdentifierEntity(context: context)
//                    idEntity.use = identifier.use
//                    idEntity.value = identifier.value
//                    idEntity.system = identifier.system
//                    return idEntity
//                }
//               // entity.addToIdentifiers(NSSet(array: identifierEntities))
//            }
            
            // You can add more nested relationships here if needed
            
            do {
                try context.save()
                print("✅ Saved resource to Core Data")
            } catch {
                print("❌ Core Data save failed: \(error)")
                throw CoreDataError.saveFailed
            }
        },
        saveConditionModel:   { model in

            let context = PersistenceController.shared.context
                    model.entry?.forEach { entry in
                        guard let resource = entry.resource else { return }
                        
                        let conditionEntity = ConditionResourceEntity(context: context)
                        conditionEntity.id = resource.id
                        conditionEntity.resourceType = resource.resourceType
                        conditionEntity.onsetDateTime = resource.onsetDateTime
                        conditionEntity.recordedDate = resource.recordedDate

                        // Clinical Status
                        if let clinical = resource.clinicalStatus {
                            let statusEntity = ClinicalStatusEntity(context: context)
                            statusEntity.text = clinical.text
                            clinical.coding?.forEach { code in
                                let codingEntity = CodingEntity(context: context)
                                codingEntity.code = code.code
                                codingEntity.display = code.display
                                codingEntity.system = code.system
                                statusEntity.addToCoding(codingEntity)
                            }
                            conditionEntity.clinicalStatus = statusEntity
                        }
                        
                        // Verification Status
                        if let verification = resource.verificationStatus {
                            let statusEntity = VerificationStatusEntity(context: context)
                            statusEntity.text = verification.text
                            verification.coding?.forEach { code in
                                let codingEntity = CodingEntity(context: context)
                                codingEntity.code = code.code
                                codingEntity.display = code.display
                                codingEntity.system = code.system
                                statusEntity.addToCoding(codingEntity)
                            }
                            conditionEntity.verificationStatus = statusEntity
                        }
                        
                        // Code
                        if let code = resource.code {
                            let codeEntity = ConditionCodeEntity(context: context)
                            codeEntity.text = code.text
                            code.coding?.forEach { coding in
                                let codingEntity = CodingEntity(context: context)
                                codingEntity.code = coding.code
                                codingEntity.display = coding.display
                                codingEntity.system = coding.system
                                codeEntity.addToCoding(codingEntity)
                            }
                            conditionEntity.code = codeEntity
                        }
                        
                        // Subject
                        if let subject = resource.subject {
                            let subjectEntity = ConditionSubjectEntity(context: context)
                            subjectEntity.reference = subject.reference
                            subjectEntity.display = subject.display
                            conditionEntity.subject = subjectEntity
                        }

                        // Category
                        resource.category?.forEach { cat in
                            let categoryEntity = ConditionCategoryEntity(context: context)
                            categoryEntity.text = cat.text
                            cat.coding?.forEach { coding in
                                let codingEntity = CodingEntity(context: context)
                                codingEntity.code = coding.code
                                codingEntity.display = coding.display
                                codingEntity.system = coding.system
                                categoryEntity.addToCoding(codingEntity)
                            }
                            conditionEntity.addToCategory(categoryEntity)
                        }
                    }
                    
                    do {
                        try context.save()
                        print("✅ ConditionModel saved")
                    } catch {
                        print("❌ Saving ConditionModel failed: \(error)")
                        throw CoreDataError.saveFailed
                    }
                },
        saveConsentModel:   { consentModel in
            let context = PersistenceController.shared.context
            
                let consentEntity = ConsentEntity(context: context)
                
                consentEntity.resourceType = consentModel.resourceType
                consentEntity.type = consentModel.type
                consentEntity.total = Int32(consentModel.total ?? 0)
                
                if let entries = consentModel.entry {
                    for entry in entries {
                        let entryEntity = ConsentEntryEntity(context: context)
                        entryEntity.fullUrl = entry.fullUrl
                        
                        if let resource = entry.resource {
                            let resourceEntity = ConsentResourceEntity(context: context)
                            resourceEntity.resourceType = resource.resourceType
                            
                            if let issues = resource.issue {
                                for issue in issues {
                                    let issueEntity = ConsentIssueEntity(context: context)
                                    issueEntity.code = issue.code
                                    issueEntity.severity = issue.severity
                                    issueEntity.diagnostics = issue.diagnostics
                                    
                                    if let details = issue.details {
                                        let detailsEntity = DetailsEntity(context: context)
                                        // Set detailsEntity fields from details
                                        issueEntity.details = detailsEntity
                                    }
                                    
                                    resourceEntity.addToIssues(issueEntity)
                                }
                            }
                            entryEntity.resource = resourceEntity
                        }
                        consentEntity.addToEntries(entryEntity)
                    }
                }

                do {
                    try context.save()
                    print("Consent data saved.")
                } catch {
                    print("Failed to save consent data: \(error)")
                }
            

        },
        saveAppoitmentModel: { appointmentModel in
            
            let context = PersistenceController.shared.context
            let appointmentEntity = AppoitmentEntity(context: context)
            appointmentModel.entry?.forEach { entry in
                let entryEntity = AppointmentEntryEntity(context: context)
                
//                let resource = entry.resource
//                if let resource = resource as? AppointmentResource {
//                    entryEntity.status = resource.status?.rawValue
//                    entryEntity.slotStart = resource.slotStart
//                    entryEntity.slotEnd = resource.slotEnd
//                    entryEntity.appointmentType = resource.appointmentType?.rawValue
//                    entryEntity.description_fhir = resource.description_fhir
//                    
//                }

                appointmentEntity.addToEntry(entryEntity)
            }
            
            do {
                try context.save()
                print("Appoitment data saved.")
            } catch {
                print("Failed to save consent data: \(error)")
            }
        },
        saveAllergyModel: { allergy in
            let context = PersistenceController.shared.context
            let entity = AllergyEntity(context: context)
            entity.allerygy_id = allergy.id
            entity.codeSystem = allergy.codeSystem
            entity.codeDisplay = allergy.codeDisplay
            entity.rawCode = allergy.rawCode
            entity.clinicalStatus = allergy.clinicalStatus
            entity.patientId = allergy.patientId
            entity.encounterId = allergy.encounterId
            entity.recordedDate = allergy.recordedDate
            entity.createdAt = allergy.createdAt
            entity.updatedAt = allergy.updatedAt

            do {
                try context.save()
            } catch {
                throw CoreDataError.saveFailed
            }
        }
    )
}

