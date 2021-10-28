//
//  ViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 20/10/2021.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {
    var TESTARRAY: [User] = [] //REMEMBER TO REMOVE
    
    @IBOutlet weak var tableView: UITableView!
    
    let deletedUserManager = DeletedUserManager()
    let userManager = UserManager()
    var context: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    let url = "https://randomuser.me/api?results=100&seed=ios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        context = userManager.getContext()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "cell")
        
        checkIfUsersExist()
        
        navigationItem.title = "Kontakter"
        
        checkNumberOfTotalUsers() //REMEMBER TO REMOVE
        deletedUserManager.fetchAllDeletedUsers() //REMEMBER TO REMOVE
    }
    
    func checkNumberOfTotalUsers() {
        let users: [User] = userManager.fetchAllUsers()
        print("Number of users in the database: \(users.count)")
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<User>(entityName: "User")
            let sort = NSSortDescriptor(key: "phone", ascending: true)
            request.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "cell")
    }
    
    func checkIfUsersExist(){
        var tempUsers: [User] = []
        
        do {
            tempUsers = try self.context.fetch(User.fetchRequest())
            loadSavedData()
        } catch {
            print("Error fetching already existing users: \(error.localizedDescription)")
        }
        //If there is zero or less items in the database, fetch results. If not, just reload the TableView
        if(tempUsers.count <= 0) {
            //Fetch API data when the app is loaded
            userManager.fetchJsonAndUpdateDatabase(from: url)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Testing functions
extension ContactsViewController {
    //TESTING CORE DATA!
    @IBAction func getDataPressed(_ sender: UIButton) {
        do {
            self.TESTARRAY = try context.fetch(User.fetchRequest())
        } catch {
            print("Error persisting to core data: \(error.localizedDescription)")
        }
        
        for user in TESTARRAY {
            print(user.email!)
        }
    }
    
    @IBAction func deleteDataPressed(_ sender: UIButton) {
        print("Deleting data....")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "DeletedUser")
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
        
        do {
            try context.execute(deleteRequest)
            try context.execute(deleteRequest2)
            
            try context.save()
            print("Data deleted.")
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - FetchedResultsController Extension
extension ContactsViewController: NSFetchedResultsControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.endUpdates()
        
    }
}

//https://github.com/jrasmusson/swift-arcade/blob/master/CoreData/2-NSFetchedResultsController.md
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsCell
        let user = fetchedResultsController.object(at: indexPath)
        
        let fullName = "\(user.firstName!) \(user.lastName!)"
        cell.textLabel?.text = fullName
        cell.imageView?.imageFromUrl(with: user.pictureThumbnail!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleContactViewController = self.storyboard?.instantiateViewController(identifier: "SingleContact") as! SingleContactViewController
        let currentUser = fetchedResultsController.object(at: indexPath)
        
        //We send the current user over to the VC
        singleContactViewController.currentUser = currentUser
        self.navigationController?.pushViewController(singleContactViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
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

