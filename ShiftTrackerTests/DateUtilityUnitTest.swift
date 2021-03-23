//
//  DateUtilityUnitTest.swift
//  ShiftTrackerTests
//
//  Created by Runa Alam on 23/3/21.
//

import XCTest
@testable import ShiftTracker

class DateUtilityUnitTest: XCTestCase {
    let unit = DateUtility()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test case - alway pass current date string so It can not be nil
    func testGetCurrentDateTimeString() {
        let instance = DateUtility.getCurrentDateTimeString()
        XCTAssertNotNil(instance)
    }
    
    
    //Test case what ever input is if unable to parse date will handle nil value and pass empty string
    func testGetDateFromISO8601() {
        let dateStr = DateUtility.getDateFromISO8601(string: "2021-03-19 22:36:42 +0000", formate: "")
        XCTAssertEqual("", dateStr)
    }
    
}
