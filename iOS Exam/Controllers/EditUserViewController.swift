//
//  EditUserViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 27/10/2021.
//

import UIKit
import CoreData

class EditUserViewController: UIViewController {
    //You wont access this screen without receiving the currentUser, so we can force unwrap it (quite) safely.
    var currentUser: User!
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
        
        //TextField delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        cityTextField.delegate = self
        phoneTextField.delegate = self
        
        navigationController?.title = "Edit User"
    }
    
    @IBAction func submitChangesPressed(_ sender: UIButton) {
        firstNameTextField.endEditing(true)

        guard let phone = currentUser.phone else { return }
        let updatedUser = userManager.editSingleUser(withAttribute: phone, user: currentUser, firstName: newFirstName, lastName: newLastName, email: newEmail, city: newCity, phone: newPhone)
        
        delegate?.updateCurrentUser(with: updatedUser)
        navigationController?.popViewController(animated: true)
    }
    
    func formatDate(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.long
        let stringDate = timeFormatter.string(from: date)
        
        return stringDate
    }
}

//this is still wonky
extension EditUserViewController: UITextFieldDelegate {
    //https://rderik.com/blog/solutions-to-common-scenarios-when-using-uitextfield-on-ios/#handling-multiple-text-fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Normally you can just assign .endEditing and other stuff to the textField variable, but
        //since I need to assign the values to seperate variables I decided to use a switch case to detect which TextField is activ
        switch textField {
        case firstNameTextField:
            newFirstName = firstNameTextField.text!
            firstNameTextField.endEditing(true)
            
        case lastNameTextField:
            newLastName = lastNameTextField.text!
            lastNameTextField.endEditing(true)
            
        case emailTextField:
            newEmail = emailTextField.text!
            emailTextField.endEditing(true)
            
        case cityTextField:
            newCity = cityTextField.text!
            cityTextField.endEditing(true)
            
        case phoneTextField:
            newPhone = phoneTextField.text!
            phoneTextField.endEditing(true)
            
        default:
            break
        }
        
        return true
    }
    
    //This runs everytime the user presses or returns the value in the TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            newFirstName = firstNameTextField.text!
            firstNameTextField.endEditing(true)
            
        case lastNameTextField:
            newLastName = lastNameTextField.text!
            lastNameTextField.endEditing(true)
            
        case emailTextField:
            newEmail = emailTextField.text!
            emailTextField.endEditing(true)
            
        case cityTextField:
            newCity = cityTextField.text!
            cityTextField.endEditing(true)
            
        case phoneTextField:
            newPhone = phoneTextField.text!
            phoneTextField.endEditing(true)
            
        default:
            break
        }
    }
}
