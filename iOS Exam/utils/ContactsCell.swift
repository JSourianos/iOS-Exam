//Move this class somewhere else
import UIKit

class ContactsCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel?
    @IBOutlet weak var cellImageView: UIImageView?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
