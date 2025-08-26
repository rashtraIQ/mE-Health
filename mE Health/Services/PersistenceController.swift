//
//  PersistenceController.swift
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
//# ============================================================================= on 28/05/25.
//

import CoreData

//class PersistenceController {
//    static let shared = PersistenceController()
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "FHIRTableModel") // same as .xcdatamodeld
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error)")
//            }
//        }
//        return container
//    }()
//
//    var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//}

import CoreData

//class PersistenceController {
//    static let shared = PersistenceController()
//
//    let fhirContainer: NSPersistentContainer
//    let adviceContainer: NSPersistentContainer
//
//    var context: NSManagedObjectContext {
//        fhirContainer.viewContext
//    }
//
//    var adviceContext: NSManagedObjectContext {
//        adviceContainer.viewContext
//    }
//
//    private init() {
//        // Load FHIRTableModel
//        guard let fhirModelURL = Bundle.main.url(forResource: "FHIRTableModel", withExtension: "momd"),
//              let fhirModel = NSManagedObjectModel(contentsOf: fhirModelURL) else {
//            fatalError("Failed to load FHIRTableModel")
//        }
//
//        fhirContainer = NSPersistentContainer(name: "FHIRTableModel", managedObjectModel: fhirModel)
//        fhirContainer.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Error loading FHIRTableModel: \(error)")
//            }
//        }
//
//        // Load AdviceModel
//        guard let adviceModelURL = Bundle.main.url(forResource: "Advice", withExtension: "momd"),
//              let adviceModel = NSManagedObjectModel(contentsOf: adviceModelURL) else {
//            fatalError("Failed to load AdviceModel")
//        }
//
//        adviceContainer = NSPersistentContainer(name: "Advice", managedObjectModel: adviceModel)
//        adviceContainer.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Error loading AdviceModel: \(error)")
//            }
//        }
//    }
//}

class PersistenceController {
    static let shared = PersistenceController()

    let fhirContainer: NSPersistentContainer
    let adviceContainer: NSPersistentContainer
    let goalContainer: NSPersistentContainer

    /// Access to FHIR Core Data context
    var context: NSManagedObjectContext {
        fhirContainer.viewContext
    }

    /// Access to Advice Core Data context
    var adviceContext: NSManagedObjectContext {
        adviceContainer.viewContext
    }
    
    /// Access to Advice Core Data context
    var goalContext: NSManagedObjectContext {
        goalContainer.viewContext
    }

    private init() {
        // Load FHIRTableModel
        guard let fhirModelURL = Bundle.main.url(forResource: "FHIRTableModel", withExtension: "momd"),
              let fhirModel = NSManagedObjectModel(contentsOf: fhirModelURL) else {
            fatalError("Error loading FHIRTableModel")
        }

        fhirContainer = NSPersistentContainer(name: "FHIRTableModel", managedObjectModel: fhirModel)
        fhirContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading FHIRTableModel: \(error)")
            }
        }

        // Load AdviceModel
        guard let adviceModelURL = Bundle.main.url(forResource: "Advice", withExtension: "momd"),
              let adviceModel = NSManagedObjectModel(contentsOf: adviceModelURL) else {
            fatalError("Error loading advicemodel")
        }

        adviceContainer = NSPersistentContainer(name: "Advice", managedObjectModel: adviceModel)
        adviceContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading advicemodel: \(error)")
            }
        }
        
        // Load GoalModel
        guard let adviceModelURL = Bundle.main.url(forResource: "HealthGoal", withExtension: "momd"),
              let adviceModel = NSManagedObjectModel(contentsOf: adviceModelURL) else {
            fatalError("Error loading advicemodel")
        }

        goalContainer = NSPersistentContainer(name: "HealthGoal", managedObjectModel: adviceModel)
        goalContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading advicemodel: \(error)")
            }
        }
    }
}

