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


struct PerformanceTestModel {
	
	enum EyeColor: String {
		case Blue = "blue"
		case Green = "green"
		case Brown = "brown"
	}
	
	enum Fruit: String {
		case Apple = "apple"
		case Banana = "banana"
		case Strawberry = "strawberry"
	}
	
	var id: String = ""
	var index:Int = 0
	var guid: String = ""
	var isActive: Bool = true //<- isActive
	var balance: String = ""
	var picture: NSURL?
	var age: Int = 0
	var eyeColor: EyeColor = .Brown //<- eyeColor
	var name: Name = Name()
	var company: String = ""
	var email: String = ""
	var phone: String = ""
	var address: String = ""
	var about: String = ""
	var registered: String = ""
	var latitude: Double = 0.0
	var longitude: Double = 0.0
	var greeting: String = ""
	var favoriteFruit: Fruit? //<- favoriteFruit
}

extension PerformanceTestModel: Serializable {
	init(dictionary: NSDictionary?) {
		id            <== (self, dictionary, "id")
		index         <== (self, dictionary, "index")
		guid          <== (self, dictionary, "guid")
		isActive      <== (self, dictionary, "isActive")
		balance       <== (self, dictionary, "balance")
//		picture       <== (self, dictionary, "picture")
		age           <== (self, dictionary, "age")
//		eyeColor      <== (self, dictionary, "eyeColor")
		name          <== (self, dictionary, "name")
		company       <== (self, dictionary, "company")
		email         <== (self, dictionary, "email")
		phone         <== (self, dictionary, "phone")
		address       <== (self, dictionary, "address")
		about         <== (self, dictionary, "about")
		registered    <== (self, dictionary, "registered")
//		latitude      <== (self, dictionary, "latitude")
//		longitude     <== (self, dictionary, "longitude")
		greeting      <== (self, dictionary, "greeting")
//		favoriteFruit <== (self, dictionary, "favoriteFruit")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")            <== id
		(dict, "index")         <== index
		(dict, "guid")          <== guid
		(dict, "isActive")      <== isActive
		(dict, "balance")       <== balance
		(dict, "picture")       <== picture
		(dict, "age")           <== age
		(dict, "eyeColor")      <== eyeColor
		(dict, "name")          <== name
		(dict, "company")       <== company
		(dict, "email")         <== email
		(dict, "phone")         <== phone
		(dict, "address")       <== address
		(dict, "about")         <== about
		(dict, "registered")    <== registered
		(dict, "latitude")      <== latitude
		(dict, "longitude")     <== longitude
		(dict, "greeting")      <== greeting
		(dict, "favoriteFruit") <== favoriteFruit
		return dict
	}
}

struct Name {
	var first = ""
	var last = ""
}

extension Name: Serializable {
	init(dictionary: NSDictionary?) {
		first <== (self, dictionary, "first")
		last  <== (self, dictionary, "last")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "first") <== first
		(dict, "last")  <== last
		return dict
	}
}


/////////////////////////////////////
/*
	Other libraries
*/


// Freddy
extension PerformanceTestModel: Freddy.JSONDecodable {
	init(json value: Freddy.JSON) throws {
		id = try value.string("id")
		index = try value.int("index")
		guid = try value.string("guid")
		isActive = try value.bool("isActive")
		balance = try value.string("balance")
		//picture = try value.
		age = try value.int("age")
		//eyeColor = try value.
		name = try value.decode("name")
		company = try value.string("company")
		email = try value.string("email")
		phone = try value.string("phone")
		address = try value.string("address")
		about = try value.string("about")
		registered = try value.string("registered")
		//latitude = try value.double("latitude")
		//longitude = try value.double("longitude")
		greeting = try value.string("greeting")
		//favoriteFruit = try value.
	}
}

extension Name: Freddy.JSONDecodable {
	init(json value: Freddy.JSON) throws {
		first = try value.string("first")
		last = try value.string("last")
	}
}

// Gloss
extension PerformanceTestModel: Gloss.Decodable {
	init?(json: Gloss.JSON) {
		id          =  "id" <~~ json ?? id
		index       =  "index" <~~ json ?? index
		guid        =  "guid" <~~ json ?? guid
		isActive    =  "isActive" <~~ json ?? isActive
		balance     =  "balance" <~~ json ?? balance
//		picture     =  "picture" <~~ json
		age         =  "age" <~~ json ?? age
//		eyeColor    =  "eyeColor" <~~ json ?? eyeColor
		name        =  "name" <~~ json ?? name
		company     =  "company" <~~ json ?? company
		email       =  "email" <~~ json ?? email
		phone       =  "phone" <~~ json ?? phone
		address     =  "address" <~~ json ?? address
		about       =  "about" <~~ json ?? about
		registered  =  "registered" <~~ json ?? registered
//		latitude    =  "latitude" <~~ json ?? latitude
//		longitude   =  "longitude" <~~ json ?? longitude
		greeting    =  "greeting" <~~ json ?? greeting
//		favoriteFruit = "favoriteFruit" <~~ json
	}
}

extension Name: Gloss.Decodable {
	init?(json: Gloss.JSON) {
		first = "first" <~~ json ?? first
		last = "last" <~~ json ?? last
	}
}

// ObjectMapper

extension PerformanceTestModel: Mappable {
	init?(_ map: Map) {
		
	}
	mutating func mapping(map: Map) {
		id				<- map["id"]
		index           <- map["index"]
		guid			<- map["guid"]
		isActive        <- map["isActive"]
		balance         <- map["balance"]
		//		picture
		age				<- map["age"]
		//		eyeColor
		name			<- map["name"]
		company         <- map["company"]
		email           <- map["email"]
		phone           <- map["phone"]
		address         <- map["address"]
		about           <- map["about"]
		registered      <- map["registered"]
		//		latitude     
		//		longitude    
		greeting        <- map["greeting"]
		//		favoriteFruit
	}
}

extension Name: Mappable {
	init?(_ map: Map) {
		
	}
	mutating func mapping(map: Map) {
		first <- map["first"]
		last <- map["last"]
	}
	
}

// JSONCodable

extension PerformanceTestModel: JSONCodable {
	init(object: JSONObject) throws {
		let decoder = JSONDecoder(object: object)
		
		id = try decoder.decode("id")
		index = try decoder.decode("index")
		guid = try decoder.decode("guid")
		isActive = try decoder.decode("isActive")
		balance = try decoder.decode("balance")
		//picture = try value.
		age = try decoder.decode("age")
		//eyeColor = try value.
		name = try decoder.decode("name")
		company = try decoder.decode("company")
		email = try decoder.decode("email")
		phone = try decoder.decode("phone")
		address = try decoder.decode("address")
		about = try decoder.decode("about")
		registered = try decoder.decode("registered")
		//latitude = try value.double("latitude")
		//longitude = try value.double("longitude")
		greeting = try decoder.decode("greeting")
		//favoriteFruit = try value.
		
		
	}
}

extension Name: JSONCodable {
	init(object: JSONObject) throws {
		let decoder = JSONDecoder(object: object)
		
		first = try decoder.decode("first")
		last = try decoder.decode("last")
		
	}
}

