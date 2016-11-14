//
//  SwiftyImpress_Tests.swift
//  SwiftyImpress Tests
//
//  Created by Pluto Y on 15/10/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

import XCTest
import SwiftyImpress

class SwiftyImpress_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConnect() {
        let t = CATransform3DIdentity
        let tt = Coordinate.x
        let ttt = transform(t) --> scale(.x, CGFloat(90))
        print(ttt(t))
        
        let test: [Transform] = [translation(10), scale(10)]
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
