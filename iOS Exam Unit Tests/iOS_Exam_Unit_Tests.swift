import XCTest
@testable import iOS_Exam
import CoreData


class iOS_Exam_Unit_Tests: XCTestCase {

    let userManager: UserManager = UserManager()
    var context: NSManagedObjectContext?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        context = userManager.getContext()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testThatAUserHasBirthday() throws {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatter.string(from: date)
        print(currentDate)
        
        let hasBirthday = userManager.checkIfUserHasBirthday(userDate: currentDate)
        XCTAssertTrue(hasBirthday)
    }
    
    //This test will be true once a week, but what can you do
    func testThatAUserDoesNotHaveBirthday() throws {
        let hasBirthday = userManager.checkIfUserHasBirthday(userDate: "2021/01/01")
        XCTAssertFalse(hasBirthday)
    }
}
