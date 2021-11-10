
import UIKit

//This protocol updates the user using delegation to share data between screens.
protocol UserDelegate {
    func updateCurrentUser(with user: User)
}

class SingleContactViewController: UIViewController, UserDelegate {
    let userManager = UserManager()
    var deletedUserManager = DeletedUserManager()
    var currentId = ""
    var currentUser = User()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateLayout(with: currentUser)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateLayout(with: currentUser)
        
        let birthWeek = userManager.checkIfUserHasBirthday(userDate: currentUser.birthdate!)
        if birthWeek {
            playBirthdayAnimation()
        }
    }
    
    func updateCurrentUser(with user: User) {
        return self.currentUser = user
    }
    
    func populateLayout(with currentUser: User) {
        if let id = currentUser.id {
            print(id)
            self.currentUser = userManager.fetchCurrentUserData(withId: id)
        } else {
            self.currentUser = User()
        }
        
        let fullName = "\(currentUser.firstName!) \(currentUser.lastName!)"
        
        let age: Int32 = currentUser.age
        userImageView.image = UIImage(data: currentUser.imageDataLarge!)
        fullNameLabel.text = fullName
        dateLabel.text = currentUser.birthdate!
        cityLabel.text = currentUser.city!
        stateLabel.text = currentUser.state!
        emailLabel.text = currentUser.email ?? "Unavailable"
        ageLabel.text = "Age: \(age) years old"
    }
}

//MARK: - Moving View When Keyboard Appears

//MARK: - Birthday functions
extension SingleContactViewController {
    
    func createRainingEmoji(with emoji: String){
        let randomXPosition = Double.random(in: 0...400)
        let randomDelay = Double.random(in: 0...1.5)
        let randomDuration = Double.random(in: 4...10)
        
        let emojiLabel = UILabel.init(frame: CGRect(x: randomXPosition, y: -200, width: 200, height: 200))
        emojiLabel.text = emoji
        emojiLabel.font = emojiLabel.font.withSize(40)
        
        
        UIView.animate(withDuration: randomDuration, delay: randomDelay, options: [.repeat, .curveEaseIn], animations: {
            emojiLabel.frame.origin = CGPoint(x: randomXPosition, y: 1500)
        }, completion: nil)
        
        view.addSubview(emojiLabel)
    }
    
    func playBirthdayAnimation() {
        
        //Birthday Label in the corner of the image view
        let birthDayLabel = UILabel.init(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        birthDayLabel.text = "🎉"
        birthDayLabel.font = birthDayLabel.font.withSize(50)
        userImageView.addSubview(birthDayLabel)
        
        //The raining emojis
        let emojies: [String] = ["🎉", "🎈", "🎂"]
        
        for _ in 1...25 {
            let randomIndex = Int.random(in: 0...2)
            createRainingEmoji(with: emojies[randomIndex])
        }
    }
}

//MARK: - Buttons
extension SingleContactViewController {
    @IBAction func deleteUserPressed(_ sender: UIButton) {        
        if let userId = currentUser.id {
            deletedUserManager.insertDeletedUser(user: currentUser)
            userManager.deleteSingleUser(withId: userId)
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func showOnMapPressed(_ sender: UIButton) {
        //Instantiate our view controller with the correct storyboard and pass over our current users id
        let singleMapViewController = self.storyboard?.instantiateViewController(identifier: "SingleMap") as! SingleMapViewController
        if let userId = currentUser.id {
            singleMapViewController.currentUserId = userId
            self.navigationController?.pushViewController(singleMapViewController, animated: true)
        }
    }
    
    @IBAction func editUserPressed(_ sender: UIButton) {
        let editUserViewController = self.storyboard?.instantiateViewController(identifier: "EditUser") as! EditUserViewController
        editUserViewController.currentUser = self.currentUser
        editUserViewController.delegate = self
        
        self.navigationController?.pushViewController(editUserViewController, animated: true)
    }
}
