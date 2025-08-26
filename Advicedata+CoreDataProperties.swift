//
//  Advicedata+CoreDataProperties.swift
//  mE Health
//
//  Created by Ishant Tiwari on 30/07/25.
//
//

import Foundation
import CoreData


extension Advicedata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Advicedata> {
        return NSFetchRequest<Advicedata>(entityName: "Advicedata")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var fav: String?
    @NSManaged public var ignore: String?
    @NSManaged public var read: String?
    @NSManaged public var review: String?
    @NSManaged public var role: String?
    @NSManaged public var title: String?
    @NSManaged public var unread: String?

}

extension Advicedata : Identifiable {

}
