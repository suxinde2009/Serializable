//
//  PerformanceTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//


import Serializable
import Freddy
import Gloss
import ObjectMapper
import JSONCodable

struct PerformanceTestSmallModel {	
	var id = ""
	var name = ""
}

extension PerformanceTestSmallModel: Serializable {
	init(dictionary: NSDictionary?) {
		id   <== (self, dictionary, "id")
		name <== (self, dictionary, "name")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")   <== id
		(dict, "name") <== name
		return dict
	}
}

/////////////////////////////////////
/*
Other libraries
*/

// Freddy
extension PerformanceTestSmallModel: Freddy.JSONDecodable {
	init(json value: Freddy.JSON) throws {
		id = try value.string("id")
		name = try value.string("name")
	}
}

// Gloss

extension PerformanceTestSmallModel: Gloss.Decodable {
	init?(json: Gloss.JSON) {
		id = "id" <~~ json ?? id
		name = "name" <~~ json ?? name
	}
}

// ObjectMapper

extension PerformanceTestSmallModel: Mappable {
	init?(_ map: Map) {
		
	}
	mutating func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
	}
}

// JSONCodable

extension PerformanceTestSmallModel: JSONCodable {
	init(object: JSONObject) throws {
		let decoder = JSONDecoder(object: object)
		id = try decoder.decode("id")
		name = try decoder.decode("name")
	}
}