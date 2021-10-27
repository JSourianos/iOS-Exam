//
//  ViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 20/10/2021.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let url = "https://randomuser.me/api?results=100&seed=ios"
    
    //CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coreDataUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We check if any there are any data in the database, if not then we fetch from the API.
        checkIfUsersExist()
       
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Kontakter"
    }
    
    func checkIfUsersExist(){
        //Fetch existing users
        do {
            coreDataUsers = try self.context.fetch(User.fetchRequest())
        } catch {
            print("Error fetching already existing users: \(error.localizedDescription)")
        }
        
        //If there is zero or less items in the database, fetch results. If not, just reload the TableView
        if(coreDataUsers.count <= 0) {
            //Fetch API data when the app is loaded
            fetchJSON(from: url)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //TESTING CORE DATA!
    @IBAction func getDataPressed(_ sender: UIButton) {
        do {
            self.coreDataUsers = try context.fetch(User.fetchRequest())
        } catch {
            print("Error persisting to core data: \(error.localizedDescription)")
        }
        
        for user in coreDataUsers {
            print(user.email)
        }
    }
    //TESTING CORE DATA
    @IBAction func deleteDataPressed(_ sender: UIButton) {
        print("Deleting data....")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Data deleted.")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }

    func fetchJSON(from url: String){
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
                    print(error)
                }
            }
            
            //Making sure our result is properly converted
            guard let json = result else {
                return
            }
            
            //Results return from the fetch
            let results = json.results
                            
            //Persist to CoreData
            for result in results {
                //We just force unwrap, since the API does not return any null values and we already guard the response object incase something goes wrong.
                //REMEMBER TO ADD POSTCODE SOMEHOW
                let newUser = User(context: self.context)
                //We can define inside our Data Model that these values wont be optionals - test this out
                //Add values from the fetch to a user object
                //Maybe this can be added in the init?
                newUser.id = result.login?.uuid!
                newUser.nameTitle = result.name?.title!
                newUser.firstName = result.name?.first!
                newUser.lastName = result.name?.last!
                newUser.birthdate = result.dob?.date! // This needs to be converted to a Date!
                newUser.cell = result.cell!
                newUser.city = result.location?.city!
                newUser.email = result.email!
                newUser.gender = result.gender!
                newUser.latitude = result.location?.coordinates?.latitude!
                newUser.longitude = result.location?.coordinates?.longitude!
                newUser.nat = result.nat!
                newUser.phone = result.phone!
                newUser.pictureThumbnail = result.picture?.thumbnail!
                newUser.state = result.location?.state!
                newUser.streetName = "\(result.location?.street?.name!)"
                newUser.streetNumber = "\(result.location?.street?.number!)"
            }
            
            //Save outside the loop so we dont overwrite
            do {
                try self.context.save()
                
                //After saving the data, we populate the array we use for the tableview
                self.coreDataUsers = try self.context.fetch(User.fetchRequest()) //We should do this here
            } catch {
                print("Error writing to database: \(error.localizedDescription)")
            }
            
            //Update the UI
            DispatchQueue.main.async {
                self.tableView.reloadData() //reload the tableView data after the fetch.
            }
        })
        
        task.resume()
    }
}


//MARK: - TableView
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataUsers.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleContactViewController = self.storyboard?.instantiateViewController(identifier: "SingleContact") as! SingleContactViewController
    
        //We send the current user over to the VC
        singleContactViewController.currentUser = coreDataUsers[indexPath.row]
        self.navigationController?.pushViewController(singleContactViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Custom class for the cell, allowing us to access the styles
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsCell
        
        let name = "\(coreDataUsers[indexPath.row].firstName!) \(coreDataUsers[indexPath.row].lastName!)"
        let image = coreDataUsers[indexPath.row].pictureThumbnail
        cell.cellLabel.text = name
        cell.cellImageView.imageFromUrl(with: image!)
        
        return cell
    }
    
}

//This extension fetches each image from the URL in the API
//MARK: -  Image Fetch Extension
extension UIImageView {
    public func imageFromUrl(with urlString: String){
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error)  in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        })
        
        task.resume()
    }
}

