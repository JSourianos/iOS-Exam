import CoreData
import UIKit

class DeletedUserManager {
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //This should work?
    func insertDeletedUser(user: User) {
        do {
            let deletedUser = DeletedUser(context: self.context)
            deletedUser.id = user.id
            
            try self.context.save()
        } catch {
            print("Error inserting deleted user: \(error.localizedDescription)")
        }
    }
    
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
                print(user.id)
            }
        } catch {
            print("Error fetching all deleted users: \(error.localizedDescription)")
        }
    }
}
