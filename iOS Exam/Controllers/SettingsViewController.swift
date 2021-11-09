import UIKit
import CoreData
//TODO: - TextFieldDelegate!
class SettingsViewController: UIViewController {

    let userManager = UserManager()
    var context: NSManagedObjectContext!
    
    var url = "https://randomuser.me/api?results=100"
    var userSeed: String = ""

    @IBOutlet weak var seedTextField: UITextField!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = userManager.getContext()
        seedTextField.delegate = self
        
        navigationItem.title = "Settings"
    }
    
    @IBAction func settingsSaveButtonPressed(_ sender: UIButton) {
        if let userInput = seedTextField.text {
            userSeed = userInput
        } else {
            userSeed = "android" //defaulting the value incase the user dont input anything
        }
                
        url = "https://randomuser.me/api?results=100&seed=\(userSeed)&nat=no"
        print("New seed: \(userSeed)")
                
        userManager.deleteNonChangedUsers()
        userManager.fetchJsonAndUpdateDatabase(from: url)
    }
}

//MARK: - UITextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
}
