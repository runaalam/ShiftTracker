//
//  ShiftTrackVCUnitTest.swift
//  ShiftTrackerTests
//
//  Created by Runa Alam on 23/3/21.
//

import XCTest
import CoreLocation
@testable import ShiftTracker

class ShiftTrackVCUnitTest: XCTestCase {
    var controller = ShiftTrackViewController()
    
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
    
    //Test case - if 2 button send to this methon, sender one will be disable and other one will be enable
    func testToggleShiftButton(){
        let buttonA = UIButton()
        let buttonB = UIButton()
        
        controller.toggleShiftButton(senderButton: buttonA, otherButton: buttonB)
        
        //Test success - if sender one false and other one true
        XCTAssertEqual(false, buttonA.isEnabled)
        XCTAssertEqual(true, buttonB.isEnabled)
        
        //Test fail - sender true and other false
        //Test fail - sender false and other false
        //Test fail - sender false and other true
    }
    
    //test for cretae shift data before save even in user denied to access the location
    func testCreateShiftDataToSave() {
        let status = CLAuthorizationStatus.denied
        controller.createShiftDataToSave(authorizationStatus: status, completionHandler: {shift in
           XCTAssertNotNil(shift)
        })
    }
}
