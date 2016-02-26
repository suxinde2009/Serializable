//
//  SerializablePerformanceTest.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Freddy
import Gloss
import ObjectMapper

class SerializablePerformanceTest: XCTestCase {

	var largeData: NSData!
	var smallData: NSData!
	
	var jsonDict: NSDictionary!
	var smallJsonDict: NSDictionary!
	
	var freddyDict: Freddy.JSON!
	var smallFreddyDict: Freddy.JSON!
	
	var glossDict: Gloss.JSON!
	var smallGlossDict: Gloss.JSON!
	
	var objectMapperDict: NSDictionary!
	var objectMapperSmallDict: NSDictionary!
	
	var jsonCodableDict: [String: AnyObject]!
	var jsonCodableSmallDict: [String: AnyObject]!
	
    override func setUp() {
        super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("PerformanceTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				largeData = data
//				jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
//				freddyDict = try JSON(data: data)
			}
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("PerformanceSmallTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				smallData = data
//				smallJsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
//				smallFreddyDict = try JSON(data: data)
			}
		} catch {
			XCTFail("Failed to prepare dictionary.")
			return
		}
    }
	

    func testBigPerformance() {
		self.measureBlock { () -> Void in
			do {
				self.jsonDict = try NSJSONSerialization.JSONObjectWithData(self.largeData, options: .AllowFragments) as? NSDictionary
				let _ = PerformanceTestModel.array(self.jsonDict["data"])
			}
			catch {
				print(error)
			}
		}
    }

	func testSmallPerformance() {
		self.measureBlock {
			do {
				self.smallJsonDict = try NSJSONSerialization.JSONObjectWithData(self.smallData, options: .AllowFragments) as? NSDictionary
				let _ = PerformanceTestSmallModel.array(self.smallJsonDict["data"])
			}
			catch {
				print(error)
			}
		}
	}

	func testFreddyFramework() {
		self.measureBlock {
			do {
				self.freddyDict = try Freddy.JSON(data: self.largeData)
				let _ = try self.freddyDict.array("data").map(PerformanceTestModel.init)
			}
			catch {
				print(error)
			}
		}
	}
	
	func testFreddyFrameworkSmallModel() {
		self.measureBlock {
			do {
				self.smallFreddyDict = try Freddy.JSON(data: self.smallData)
				let _ = try self.smallFreddyDict.array("data").map(PerformanceTestSmallModel.init)
			}
			catch {
				print(error)
			}
		}
	}
	
	func testGlossFramework() {
		self.measureBlock {
			do {
				self.glossDict = try NSJSONSerialization.JSONObjectWithData(self.largeData, options: .AllowFragments) as? Gloss.JSON
				if let objects = self.glossDict["data"] as? [Gloss.JSON] {
					let _ = [PerformanceTestModel].fromJSONArray(objects)
				}
				
			}
			catch {
				print(error)
			}
		}
	}
	
	func testGlossFrameworkSmallModel() {
		self.measureBlock {
			do {
				self.smallGlossDict = try NSJSONSerialization.JSONObjectWithData(self.smallData, options: .AllowFragments) as? Gloss.JSON
				if let objects = self.smallGlossDict["data"] as? [Gloss.JSON] {
					let _ = [PerformanceTestSmallModel].fromJSONArray(objects)
				}
			}
			catch {
				print(error)
			}
		}
	}
	
	func testObjectMapperFramework() {
		self.measureBlock {
			do {
				self.objectMapperDict = try NSJSONSerialization.JSONObjectWithData(self.largeData, options: .AllowFragments) as? NSDictionary
				let _ = Mapper<PerformanceTestModel>().mapArray(self.objectMapperDict["data"])
			}
			catch {
				print(error)
			}
		}
	}
	
	func testObjectMapperFrameworkSmallModel() {
		self.measureBlock {
			do {
				self.objectMapperSmallDict = try NSJSONSerialization.JSONObjectWithData(self.smallData, options: .AllowFragments) as? NSDictionary
				let _ = Mapper<PerformanceTestSmallModel>().mapArray(self.objectMapperSmallDict["data"])
			}
			catch {
				print(error)
			}
		}
	}
	
	func testJSONCodableFramework() {
		self.measureBlock {
			do {
				self.jsonCodableDict = try NSJSONSerialization.JSONObjectWithData(self.largeData, options: .AllowFragments) as? [String: AnyObject]
				let _ = Array<PerformanceTestModel>(JSONArray: self.jsonCodableDict["data"] as! [[String: AnyObject]])
			}
			catch {
				print(error)
			}
		}
	}
	
	func testJSONCodableFrameworkSmallModel() {
		self.measureBlock {
			do {
				self.jsonCodableSmallDict = try NSJSONSerialization.JSONObjectWithData(self.smallData, options: .AllowFragments) as? [String: AnyObject]
				let _ = Array<PerformanceTestSmallModel>(JSONArray: self.jsonCodableSmallDict["data"] as! [[String: AnyObject]])
				
			}
			catch {
				print(error)
			}
		}
	}
}

