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
