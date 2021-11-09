import UIKit
import CoreData

class UserManager {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteNonChangedUsers(){
        let users: [User] = self.fetchAllUsers()
        
        do {
            for user in users {
                if user.hasChanged == false {
                    context.delete(user)
                }
            }
            try context.save()
        } catch {
            print("error in changeSeed: \(error.localizedDescription)")
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return self.context
    }
    
    //TODO: Maybe this can be refactored?
    func fetchCurrentUserData(withFirstName firstname: String) -> User {
        var currentUser: User = User()
        let fetchRequest = fetchSingleUser(firstname, formatAttribute: "firstName")
        
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
    
    func fetchCurrentUserData(withId id: String) -> User {
        var currentUser: User = User()
        let fetchRequest = fetchSingleUser(id, formatAttribute: "id")
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
    func editSingleUser(withAttribute id: String, user: User, firstName: String?, lastName: String?, birthDate: String?, email: String?, city: String?, phone: String?) -> User {
        
        var currentUser: User = user
        let request = fetchSingleUser(id, formatAttribute: "id")
        
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
            
            if let birthDate = birthDate {
                currentUser.birthdate = birthDate
                currentUser.age = getAgeFromDOF(date: birthDate)
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
    
    func checkIfUserHasBirthday(userDate: String) -> Bool {
        //https://stackoverflow.com/questions/36861732/convert-string-to-date-in-swift
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter1.date(from: userDate)!
        
        print("date from string: \(date)")
        let userWeek = calendar.component(.weekOfYear, from: date)
        
        print("Current week of the year baby: \(weekOfYear)")
        print("Curren week from the birthday: \(userWeek)")
        
        //If the user date is within the same week as the current, we play the animation.
        if weekOfYear == userWeek {
            return true
        } else {
            return false
        }
    }
    
    
    //https://newbedev.com/calculate-age-from-birth-date-using-nsdatecomponents-in-swift
    func getAgeFromDOF(date: String) -> Int32 {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)

        let calender = Calendar.current

        let dateComponent = calender.dateComponents([.year, .month, .day], from:
        dateOfBirth!, to: Date())

        return Int32(dateComponent.year!)
    }
    
    //TODO: - We need to implement the second entity here, so we wont refetch the user from the API
    func deleteSingleUser(withId attribute: String) {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", attribute)
        
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
    
    func fetchSingleUser(_ attribute: String, formatAttribute: String) -> NSFetchRequest<User> {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        let predicate = "\(formatAttribute) like %@"
        fetchRequest.predicate = NSPredicate(format: predicate, attribute)
        
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
    
    func fetchJsonWithReturn(from url: String) -> [Result] {
        var results: [Result] = []
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
            results = json.results
            
            
            for result in results {
                print("Results from fetchJsonWithReturn: \(result.name.first)")
            }
            
        })
        task.resume()
        
        return results
    }
    
    
    func fetchJsonAndUpdateDatabase(from url: String) {
        var results: [Result] = []
        let url = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //Error handling
            if let error = error {
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
            
            //Results returned from the fetch
            results = json.results
            
            var deletedUsers: [DeletedUser] = []
            //var changedUsers: [User] = []
            do {
                deletedUsers = try self.context.fetch(DeletedUser.fetchRequest())
                //changedUsers = try self.context.fetch((User.fetchRequest())
            } catch {
                print("Error fetching deleted users from fetchJson: \(error.localizedDescription)")
            }
            
            for result in results {
                //Checking if our DeletedUser entity contains the userID from the API
                if deletedUsers.contains(where: { $0.id == result.login.uuid }) {
                    print("Deleted user detected.")
                    
                } else {
                    //We just force unwrap, since the API does not return any null values and we already guard the response object incase something goes wrong.
                    let newUser = User(context: self.context)
                    
                    //Format date properly
                    var date = result.dob.date
                    date = date.formatDate(format: "yyyy/MM/dd", with: date)
                    
                    newUser.id = result.login.uuid
                    newUser.age = Int32(result.dob.age)
                    newUser.nameTitle = result.name.title
                    newUser.firstName = result.name.first
                    newUser.lastName = result.name.last
                    newUser.birthdate = date
                    newUser.cell = result.cell
                    newUser.city = result.location.city
                    newUser.email = result.email
                    newUser.gender = result.gender
                    newUser.latitude = result.location.coordinates.latitude
                    newUser.longitude = result.location.coordinates.longitude
                    newUser.nat = result.nat
                    newUser.phone = result.phone
                    newUser.pictureThumbnail = result.picture.thumbnail
                    newUser.pictureLarge = result.picture.large
                    newUser.state = result.location.state
                    newUser.streetName = result.location.street.name
                    newUser.streetNumber = String(result.location.street.number)
                }
            }
            
            //Save outside the loop so we dont overwrite
            do {
                try self.context.save()
            } catch {
                print("Error writing to database: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}
