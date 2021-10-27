//
//  EditUserViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 27/10/2021.
//

import UIKit

class EditUserViewController: UIViewController {
    var currentUser = User()
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    
    //This code runs when we press the submit changes button
    @IBAction func submitChangesPressed(_ sender: UIButton) {
        firstNameTextField.endEditing(true)
        lastNameTextField.endEditing(true)
        datePicker.endEditing(true)
        emailTextField.endEditing(true)
        
        print(firstNameTextField.text ?? "")
        print(lastNameTextField.text ?? "")
        print(formatDate(date: datePicker.date))
        print(emailTextField.text ?? "")
        // do what you want to do with the string.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func formatDate(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.long
        let stringDate = timeFormatter.string(from: date)
        
        return stringDate
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
//Not sure
extension EditUserViewController: UITextFieldDelegate {
    //This is by pressing the enter or "go" field on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.endEditing(true) //Dismiss keyboard
        print(firstNameTextField.text!)
        return true
    }
    
    //This wont allow the user to end typing if the string is empty
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //If the text field is not empty, then we can reeturn true
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a city"
            return false
        }
    }
    
    //This runs everytime the user presses or returns the value in the TextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //We use an if let statement to turn the Optinal String into a defenite string, and we make sure that this will be correct.
        if let testText = textField.text {
            print(testText)
        }
        /*
        //We want to search for the City here, before resetting the textField
        firstNameTextField.text = ""
         */
    }
}
