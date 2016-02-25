//
//  SerializablePerformanceTest.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class SerializablePerformanceTest: XCTestCase {

	var jsonDict: NSDictionary!
	var smallJsonDict: NSDictionary!
	
    override func setUp() {
        super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("PerformanceTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
			}
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("PerformanceSmallTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				smallJsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
			}
		} catch {
			XCTFail("Failed to prepare  dictionary.")
			return
		}
    }
	

    func testBigPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
			let _ = PerformanceTestModel.array(self.jsonDict["data"])
        }
    }
	
	func testSmallPerformance() {
		self.measureBlock {
			// Put the code you want to measure the time of here.
			let _ = PerformanceTestModel.array(self.jsonDict["data"])
		}
	}

}

