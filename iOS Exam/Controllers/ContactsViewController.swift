import UIKit
import CoreData

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let deletedUserManager = DeletedUserManager()
    let userManager = UserManager()
    var context: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    let url = "https://randomuser.me/api?results=100&seed=ios&nat=no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = userManager.getContext()
        
        setupFRC()
        tableViewSetup()
        checkIfUsersExist()
        
        navigationItem.title = "Kontakter"
        
        checkNumberOfTotalUsers() //REMEMBER TO REMOVE
    }
    
    //TODO: - Remove this function
    func checkNumberOfTotalUsers() {
        let users: [User] = userManager.fetchAllUsers()
        print("Number of users in the database: \(users.count)")
    }
}

//MARK: - TableView & FRC Setup Functions
extension ContactsViewController {
    func setupFRC() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<User>(entityName: "User")
            let sort = NSSortDescriptor(key: "insertedAt", ascending: true)
            request.sortDescriptors = [sort]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
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

        } catch {
            print("Error fetching already existing users: \(error.localizedDescription)")
        }

        //If there is zero or less items in the database, fetch results. If not, just reload the TableView
        if(tempUsers.count <= 0) {
            //Fetch API data when the app is loaded
            userManager.fetchJsonAndUpdateDatabase(from: url)
        } else {
            tableView.reloadData()
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
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade) // add .none here, and we have no animation ( but it looks ugly)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }

            tableView.moveRow(at: indexPath, to: newIndexPath)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        tableView.endUpdates()
    }
}

//MARK: - TableView Data Source and Delegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = fetchedResultsController.object(at: indexPath)
        
        let fullName = "\(user.firstName ?? "") \(user.lastName ?? "")"
        cell.textLabel?.text = fullName
        
        if let imageData = user.imageDataThumbnail {
            cell.imageView?.image = UIImage(data: imageData)
        }
                
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
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
}
