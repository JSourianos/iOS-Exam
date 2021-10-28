import UIKit
import CoreData

class UserManager {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getContext() -> NSManagedObjectContext {
        return self.context
    }
    
    func fetchCurrentUserData(attribute: String) -> User {
        var currentUser: User = User()
        let fetchRequest = fetchSingleUser(attribute)
        do {
            let results = try context.fetch(fetchRequest)
            
            if(results.count == 0) {
                //Inserting
            } else {
                //Retrieveing
                currentUser = results.first!
            }
        } catch {
            print("Something went wrong in fetchCurrenUserData: \(error.localizedDescription)")
        }
        
        return currentUser
    }
    
    //This needs to take the datePicker aswell
    func editSingleUser(withAttribute attribute: String, user: User, firstName: String?, lastName: String?, email: String?, city: String?, phone: String?) -> User {
        
        var currentUser: User = user
        let request = fetchSingleUser(attribute)
        
        do {
            let results: [User] = try context.fetch(request)
            
            if results.count == 0 {
                //Do something
            } else {
                currentUser = results.first!
            }
            
            //We change this property to true, so we wont delete it when we refetch a new seed from the API
            currentUser.hasChanged = true
            
            //Error handling, in case the user dont want to edit everything
            if let firstName = firstName {
                currentUser.firstName = firstName
            }
            
            if let lastName = lastName {
                currentUser.lastName = lastName
            }
            
            if let email = email {
                currentUser.email = email
            }
            
            if let city = city {
                currentUser.city = city
            }
            
            if let phone = phone {
                currentUser.phone = phone
            }
            
            try context.save()
        } catch {
            print("Error editing user: \(error.localizedDescription)")
        }
        
        return currentUser
    }
    
    //TODO: - We need to implement the second entity here, so we wont refetch the user from the API
    func deleteSingleUser(_ attribute: String) {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "phone LIKE %@", attribute)
        
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                self.context.delete(user)
            }
            
            try self.context.save()
        } catch {
            print("Error deleting single user: \(error.localizedDescription)")
        }
    }
    
    func fetchSingleUser(_ attribute: String) -> NSFetchRequest<User> {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "phone LIKE %@", attribute)
        
        return fetchRequest
    }
    
    func fetchAllUsers() -> [User] {
        var users: [User] = []
        do {
            users = try self.context.fetch(User.fetchRequest())
        } catch {
            print("Error in User.swift with fetching all users \(error.localizedDescription)")
            
            return []
        }
        return users
    }
    /*
    func updateSeed(with url: String) {
        print("seed updating...")
        print("New URL: \(url) ")
        
        let results = fetchJSON(from: url)
        for result in results {
            print("Does this even hit")
            print(result.name.first)
        }
    }
     */

    func fetchJSON(from url: String) {
        let url = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //Error handling
            if let error = error {
                //Here we could maybe use DispatchQueue to update the UI, letting the user know that there has been an error
                print("An error has occured: \(error)" )
                return
            }
            
            var result: UserModel?
            
            if let data = data {
                do {
                    result = try JSONDecoder().decode(UserModel.self, from: data)
                }catch {
                    print("an error has occured: \(error.localizedDescription)")
                }
            }
            
            //Making sure our result is properly converted
            guard let json = result else {
                return
            }
            
            //Results return from the fetch
            let results = json.results
            
            
            for result in results {
                print("Results from fetchJson: \(result.name.first)")
            }
            
             //NOTE: - We should return results from this function
             //Persist to CoreData
             for result in results {
             //We just force unwrap, since the API does not return any null values and we already guard the response object incase something goes wrong.
             //REMEMBER TO ADD POSTCODE SOMEHOW
             let newUser = User(context: self.context)
             
             //Maybe this can be added in the init?
             //newUser.id = result.login.uuid
             newUser.nameTitle = result.name.title
             newUser.firstName = result.name.first
             newUser.lastName = result.name.last
             newUser.birthdate = result.dob.date // This needs to be converted to a Date!
             newUser.cell = result.cell
             newUser.city = result.location.city
             newUser.email = result.email
             newUser.gender = result.gender
             newUser.latitude = result.location.coordinates.latitude
             newUser.longitude = result.location.coordinates.longitude
             newUser.nat = result.nat
             newUser.phone = result.phone
             newUser.pictureThumbnail = result.picture.thumbnail
             newUser.state = result.location.state
             newUser.streetName = result.location.street.name
             newUser.streetNumber = String(result.location.street.number)
             }
             
             //Save outside the loop so we dont overwrite
             do {
             try self.context.save()
             } catch {
             print("Error writing to database: \(error.localizedDescription)")
             }
             
             DispatchQueue.main.async {
             //We need some way of updating the tableView from outside the ContactViewController
             //self.tableView.reloadData()
             }
        })
        task.resume()
    
    }
}
