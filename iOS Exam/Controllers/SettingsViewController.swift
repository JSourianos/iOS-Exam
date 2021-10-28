//
//  SettingsViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 20/10/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    let userManager = UserManager()
    var url = "https://randomuser.me/api?results=100"
    var userSeed: String = ""
    
    
    @IBOutlet weak var seedTextField: UITextField!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
    }
    
    
    @IBAction func settingsSaveButtonPressed(_ sender: UIButton) {
        if let userInput = seedTextField.text {
            userSeed = userInput
        }

        url = "https://randomuser.me/api?results=100&seed=\(userSeed)"
        print("Saved pressed!")
        print("New seed: \(userSeed)")
        
        //updateSeed()
    }
    // TODO: - Create Seed Change Functionality

    /*
    func updateSeed() {
        print("seed updating...")
        print("New URL: \(url) ")
        
        print("before fetching results")
        let results: [Result] = userManager.fetchJSON(from: url)
        print("after fetching results")
        for result in results {
            print("Does this even hit")
            print(result.name.first)
        }
        //2. We then need to delete everyone in the Database which havent been changed (hasChanged = false)
        //3. Then we need to fetch from API with the new url.
        //4. We then need to update the tableView in ContactViewController (I think this will be updated automatically)

    }
     */
    
}
