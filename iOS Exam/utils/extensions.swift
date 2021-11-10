import Foundation
import UIKit

//MARK: - String Extension
extension String {
    //This has to return a string, baby
    func formatDate(format: String, with date: String) -> String {
        let indexOfString = date.index(date.startIndex, offsetBy: 10)
        let formattedDate = date[..<indexOfString]
        
        return String(formattedDate)
    }
}
//MARK: - Date Picker Extension
extension UIDatePicker {
    func turnDateToString(datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        
        return dateString
    }
}

//MARK: -  Image Fetch Extension
extension UIImageView {
    public func imageFromUrl(with urlString: String){
        let url = URL(string: urlString)
        DispatchQueue.global().async {            
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error)  in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            })
            
            task.resume()
        }
    }
}


