//
//  SettingsViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 20/10/2021.
//

import UIKit
import CoreData

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
        
        navigationItem.title = "Settings"
    }
    
    @IBAction func settingsSaveButtonPressed(_ sender: UIButton) {
        if let userInput = seedTextField.text {
            userSeed = userInput
        } else {
            userSeed = "android" //defaulting the value incase the user dont input anything
        }

        url = "https://randomuser.me/api?results=100&seed=\(userSeed)"
        print("New seed: \(userSeed)")
                
        userManager.deleteNonChangedUsers()
        userManager.fetchJsonAndUpdateDatabase(from: url)
    }
}
