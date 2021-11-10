import UIKit
import CoreData

class EditUserViewController: UIViewController {
    //You wont access this screen without receiving the currentUser, so we can force unwrap it (quite) safely.
    var currentUser = User()
    var userManager = UserManager()
    
    var activeTextField: UITextField!
    var delegate: UserDelegate?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var newFirstName: String?
    var newLastName: String?
    var newBirthdate: String?
    var newEmail: String?
    var newCity: String?
    var newPhone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Datepicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        //TextField delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        cityTextField.delegate = self
        phoneTextField.delegate = self
        
        addUserValuesToTextField(from: currentUser)
        
        setKeyboardNotifications()
        
        navigationController?.navigationItem.title = "Edit User"
    }
    
}
//MARK: - User Values and Submit Button
extension EditUserViewController {
    
    func addUserValuesToTextField(from user: User) {
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        cityTextField.text = user.city
        phoneTextField.text = user.phone
    }
    
    @IBAction func submitChangesPressed(_ sender: UIButton) {
        guard let id = currentUser.id else { return }
        
        let updatedUser = userManager.editSingleUser(withAttribute: id, user: currentUser, firstName: newFirstName, lastName: newLastName, birthDate: newBirthdate, email: newEmail, city: newCity, phone: newPhone)
        
        delegate?.updateCurrentUser(with: updatedUser)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - DatePicker
extension EditUserViewController {
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        newBirthdate = turnDateToString(datePicker: picker)
    }
    
    func turnDateToString(datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        
        return dateString
    }
}
//MARK: - Moving ScrollView when Keyboard appears
//https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
extension EditUserViewController {
    
    func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}
//MARK: - UITextFieldDelegate
extension EditUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Normally you can just assign .endEditing and other stuff to the textField variable, but
        //since I need to assign the values to seperate variables I decided to use a switch case to detect which TextField is activ
        switch textField {
        case firstNameTextField:
            firstNameTextField.endEditing(true)
            
        case lastNameTextField:
            lastNameTextField.endEditing(true)
            
        case emailTextField:
            emailTextField.endEditing(true)
            
        case cityTextField:
            cityTextField.endEditing(true)
            
        case phoneTextField:
            phoneTextField.endEditing(true)
            
        default:
            break
        }
        
        return true
    }
    
    //This runs everytime the user presses or returns the value in the TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //General check, just reveals a placeholder text if the user dont input anything
        if textField.text == "" {
            textField.placeholder = "This cannot be empty."
        }
        
        switch textField {
        case firstNameTextField:
            if firstNameTextField.text == "" {
                firstNameTextField.endEditing(false)
            } else {
                newFirstName = firstNameTextField.text!
                firstNameTextField.endEditing(true)
            }
        case lastNameTextField:
            if lastNameTextField.text == "" {
                lastNameTextField.endEditing(false)
            } else {
                newLastName = lastNameTextField.text!
                lastNameTextField.endEditing(true)
            }
            
        case emailTextField:
            if emailTextField.text == "" {
                emailTextField.endEditing(false)
            } else {
                newEmail = emailTextField.text!
                emailTextField.endEditing(true)
            }
            
        case cityTextField:
            if cityTextField.text == "" {
                cityTextField.endEditing(false)
            } else {
                newCity = cityTextField.text!
                cityTextField.endEditing(true)
            }
            
        case phoneTextField:
            if phoneTextField.text == "" {
                phoneTextField.endEditing(false)
            } else {
                newPhone = phoneTextField.text!
                phoneTextField.endEditing(true)
            }
        default:
            break
        }
    }
}
