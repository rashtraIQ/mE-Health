//
//  ClinicState+CoreDataProperties.swift
//  mE Health
//
//  Created by Rashida on 10/07/25.
//
//

import Foundation
import CoreData


extension ClinicState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClinicState> {
        return NSFetchRequest<ClinicState>(entityName: "ClinicState")
    }

    @NSManaged public var count: Int64
    @NSManaged public var logo: String?
    @NSManaged public var state: String?

}

extension ClinicState : Identifiable {

}
