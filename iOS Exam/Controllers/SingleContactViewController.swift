//
//  SingleContactViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 25/10/2021.
//

import UIKit

class SingleContactViewController: UIViewController {
    
    var currentUser = User()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func showOnMapPressed(_ sender: UIButton) {
        //Instantiate our view controller with the correct storyboard and pass over our current user
        let singleMapViewController = self.storyboard?.instantiateViewController(identifier: "SingleMap") as! SingleMapViewController
        singleMapViewController.currentUser = currentUser
        self.navigationController?.pushViewController(singleMapViewController, animated: true)
    }
    
    @IBAction func editUserPressed(_ sender: UIButton) {
        print("Edit user button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Single contact baby")
        //        cell.cellImageView.imageFromUrl(with: image!)
        
        let imageUrl = currentUser.pictureThumbnail
        userImageView.imageFromUrl(with: imageUrl!)
        
        dateLabel.text = "\(currentUser.birthdate!)"
        cityLabel.text = "\(currentUser.city!)"
        stateLabel.text = "\(currentUser.state!)"
        emailLabel.text = "\(currentUser.email!)"
        
        navigationItem.title = "\(currentUser.firstName!) \(currentUser.lastName!)"
    }
}
