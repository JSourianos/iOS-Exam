
import UIKit

//This protocol just updates the user we have here
protocol UserDelegate {
    func updateCurrentUser(with user: User)
}


class SingleContactViewController: UIViewController, UserDelegate {
    let userManager = UserManager()
    var currentUser = User()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    //ADD PHONENUMBER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateLayout(with: currentUser)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateLayout(with: currentUser)
    }
    
    func updateCurrentUser(with user: User) {
        return self.currentUser = user
    }
    
    func populateLayout(with currentUser: User) {
        if let phone = currentUser.phone {
            self.currentUser = userManager.fetchCurrentUserData(attribute: phone)
        } else {
            self.currentUser = User()
            print("No phone number??")
        }
        
        let fullName = "\(currentUser.firstName!) \(currentUser.lastName!)"
        
        userImageView.imageFromUrl(with: currentUser.pictureThumbnail!)
        ageLabel.text = fullName
        dateLabel.text = currentUser.birthdate!
        cityLabel.text = currentUser.city!
        stateLabel.text = currentUser.state!
        emailLabel.text = currentUser.email ?? "Unavailable"
    }
}

//MARK: - Buttons
extension SingleContactViewController {
    @IBAction func deleteUserPressed(_ sender: UIButton) {
        
        let phone = currentUser.phone!
        userManager.deleteSingleUser(phone)
        print("User deleted")
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showOnMapPressed(_ sender: UIButton) {
        //Instantiate our view controller with the correct storyboard and pass over our current user
        let singleMapViewController = self.storyboard?.instantiateViewController(identifier: "SingleMap") as! SingleMapViewController
        singleMapViewController.currentUser = currentUser
        self.navigationController?.pushViewController(singleMapViewController, animated: true)
    }
        
    @IBAction func editUserPressed(_ sender: UIButton) {
        let editUserViewController = self.storyboard?.instantiateViewController(identifier: "EditUser") as! EditUserViewController
        editUserViewController.currentUser = self.currentUser
        editUserViewController.delegate = self
        //turn this into a segway pls
        self.navigationController?.pushViewController(editUserViewController, animated: true)
    }
}
