//
//  Goal+CoreDataProperties.swift
//  mE Health
//
//  Created by Ishant Tiwari on 04/08/25.
//
//

import Foundation
import CoreData


//extension Goal {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
//        return NSFetchRequest<Goal>(entityName: "Goal")
//    }
//
//    @NSManaged public var id: String?
//    @NSManaged public var goalDescrition: String?
//    @NSManaged public var date: String?
//
//}

// Goal+CoreDataProperties.swift
extension Goal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: String?
    @NSManaged public var goalDescrition: String?
    @NSManaged public var date: String?
}


extension Goal : Identifiable {

}
