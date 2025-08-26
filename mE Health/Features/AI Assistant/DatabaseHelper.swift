//
//  DatabaseHelper.swift
//  mE Health
//
//  Created by Ishant Tiwari on 30/07/25.
//

import Foundation
import CoreData
import UIKit

import Foundation
import CoreData

class DataBaseHelper {
    static let shared = DataBaseHelper()
    private let context = PersistenceController.shared.adviceContext
  //  let container: NSPersistentContainer

    func save(object: [String: String]) {
        let advice = Advicedata(context: context)
        advice.content = object["content"]
        advice.role = object["role"]
        advice.title = object["title"]
        advice.date = object["date"]
        advice.fav = object["fav"]
        advice.ignore = object["ignore"]
        advice.review = object["review"]
        advice.read = object["read"]
        advice.unread = object["unread"]

        do {
            try context.save()
            print("✅ Data saved successfully")
        } catch {
            print("❌ Error saving data: \(error.localizedDescription)")
        }
    }
    
    func updateAdviceItem(id: NSManagedObjectID, newRead: String?, fav: String?) {
            do {
                if var advice = try context.existingObject(with: id) as? AdviceItemData {
                    if var newRead = newRead {
                        advice.read = newRead
                    }
                    if var fav = fav {
                        advice.fav = fav
                    }
                    try context.save()
                    print("✅ Updated successfully.")
                }
            } catch {
                print("❌ Failed to update: \(error.localizedDescription)")
            }
        }

    func getAssistData() -> [Advicedata] {
        var getAssitdata :[Advicedata] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Advicedata")
        do {
            getAssitdata = try context.fetch(fetchRequest) as [Advicedata]
        }
        catch{
            print("not get data")
        }
        return getAssitdata
    }
}


class GoaldataBaseHelper {
    static let sharedGoal = GoaldataBaseHelper()
    private let contextgoal = PersistenceController.shared.goalContext
 

    func saveGoal(object: [String: String]) {
        let goalobject = Goal(context: contextgoal)
        goalobject.id = object["id"]
        goalobject.goalDescrition = object["goalDescrition"]
        goalobject.date = object["date"]
      

        do {
            try contextgoal.save()
            print("✅ Goal Data saved successfully")
        } catch {
            print("❌ Error saving data: \(error.localizedDescription)")
        }
    }
    
    func updateGoal(_ goal: Goal) {
        do {
            try contextgoal.save()
            print("✅ Goal updated successfully")
        } catch {
            print("❌ Failed to update goal: \(error.localizedDescription)")
        }
    }
    


    func getGoalData() -> [Goal] {
        var getGoaldata :[Goal] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Goal")
        do {
            getGoaldata = try contextgoal.fetch(fetchRequest) as [Goal]
        }
        catch{
            print("not get data")
        }
        return getGoaldata
    }
    
    func deleteGoal(by id: String) {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try contextgoal.fetch(fetchRequest)
            for goal in results {
                contextgoal.delete(goal)
            }
            try contextgoal.save()
            print("🗑️ Goal deleted successfully.")
        } catch {
            print("❌ Failed to delete goal: \(error.localizedDescription)")
        }
    }
    
    func updateGoal(by id: String,updatecomment:String,updateDate:String) {
        let context = PersistenceController.shared.goalContext
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        // FIX: unwrap and pass the correct ID type
       //guard let goalID = selectedGoalToEdit.id else { return }
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingGoal = results.first {
                existingGoal.goalDescrition = updatecomment
                existingGoal.date = updateDate
                try context.save()
                
               
            }
        } catch {
            print("❌ Failed to update: \(error)")
        }
    }

}




