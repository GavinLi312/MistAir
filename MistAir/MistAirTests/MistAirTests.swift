//
//  MistAirTests.swift
//  MistAirTests
//
//  Created by Salamender Li on 10/10/18.
//  Copyright © 2018 Salamender Li. All rights reserved.
//

import XCTest

@testable import MistAir

class MistAirTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDateDifference(){
        let date1 = NSDate()
        let date2 = NSDate(timeIntervalSinceNow: 2400)
        print(NSDate.caulculateTimeDifference(date1: date1, date2: date2))
        
    }
    
    func testTimeZone(){
        let now = NSDate()
    }
}
