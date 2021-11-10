import CoreData
import UIKit

class DeletedUserManager {
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func insertDeletedUser(user: User) {
        do {
            let deletedUser = DeletedUser(context: self.context)
            deletedUser.id = user.id
            
            try self.context.save()
        } catch {
            print("Error inserting deleted user: \(error.localizedDescription)")
        }
    }
    //TODO: - Check if this is needed.
    //Mostly for testing purposes
    func fetchAllDeletedUsers() {
        do {
            let results: [DeletedUser] = try context.fetch(DeletedUser.fetchRequest())
            
            if results.count == 0 {
                print("no deleted users. ")
            }
            
            if results.count > 0 {
                print("We have deleted users! ")
            }
            
            for user in results {
                print(user.id ?? "0")
            }
        } catch {
            print("Error fetching all deleted users: \(error.localizedDescription)")
        }
    }
}
