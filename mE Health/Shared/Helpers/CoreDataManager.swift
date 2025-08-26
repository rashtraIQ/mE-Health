
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ClinicModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
