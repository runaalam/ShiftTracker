//
//  DeputyServiceUnitTest.swift
//  ShiftTrackerTests
//
//  Created by Runa Alam on 23/3/21.
//

import XCTest
@testable import ShiftTracker

class DeputyServiceUnitTest: XCTestCase {
    var api = DeputyApiClient()
    
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
    
    //Test case - passing empty body in post request
    func testTaskForRequest() {
        let url = DeputyApiClient.Endpoints.shiftEnd.url
        let promise = expectation(description: Constants.Message_Request_Fail)
        let method = "POST"
        
        DeputyApiClient.taskForRequest(url: url, httpMethod: method, responseType: String.self, body: "", completion: {requestResponse , error in
            promise.fulfill()
            XCTAssertNil(error)
        })
        wait(for: [promise], timeout: 5)
    }
}
