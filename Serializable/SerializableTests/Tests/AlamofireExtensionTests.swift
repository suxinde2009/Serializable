//
//  AlamofireExtensionTests.swift
//  Serializable
//
//  Created by Chris Combs on 18/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable
import Alamofire

class AlamofireExtensionTests: XCTestCase {
	
	let manager = Manager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
 
	
	func testAlamofireExtension() {
		let expectation = self.expectation(withDescription: "Expected network request success")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break // Fail
				
			}
		}
        let _ = manager.request(.GET, "http://httpbin.org/get").responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	
	func testAlamofireExtensionBadJSON() {
		let expectation = self.expectation(withDescription: "Expected bad data from response")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		let _ = manager.request(.GET, "http://httpbin.org/deny").responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}

	
	func testAlamofireExtensionBadJSONObject() {
		let expectation = self.expectation(withDescription: "Expected bad object from response")
		let handler:(Alamofire.Response<[NetworkTestModel], NSError>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		let _ = manager.request(.GET, "http://httpbin.org/get").responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	func testAlamofireExtensionUnexpectedArrayJSON() {
		let expectation = self.expectation(withDescription: "Expected array data to single object from response")
		let handler:(Alamofire.Response<DecodableModel, NSError>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		let _ = manager.request(.GET, "https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/ArrayTest.json").responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	func testAlamofireExtensionEmptyJSON() {
		let expectation = self.expectation(withDescription: "Expected empty response")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		let _ = manager.request(.GET, "https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/Empty.json").responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	func testAlamofireArrayUnwrapper() {
		let expectation = self.expectation(withDescription: "Expected unwrapped array response")
		let handler:(Alamofire.Response<[DecodableModel], NSError>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break
			}
		}
		let unwrapper: Parser.Unwrapper = { $0.0["data"] }
		
		let _ = manager.request(.GET,
			"https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json")
			.responseSerializable(handler, unwrapper: unwrapper)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	
	func testAlamofireArrayNotUnwrapped() {
		let expectation = self.expectation(withDescription: "Expected unwrapped array response")
		let handler:(Alamofire.Response<[DecodableModel], NSError>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}		
		
		let _ = manager.request(.GET,
			"https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json")
			.responseSerializable(handler)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
	func testAlamofireWrongTypeUnwrapper() {
		let expectation = self.expectation(withDescription: "Expected unwrapped array response")
		let handler:(Alamofire.Response<DecodableModel, NSError>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break
			}
		}
		let unwrapper: Parser.Unwrapper = { $0.0["data"] }
		
		let _ = manager.request(.GET,
			"https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json")
			.responseSerializable(handler, unwrapper: unwrapper)
		waitForExpectations(withTimeout: 5, handler: nil)
	}
}