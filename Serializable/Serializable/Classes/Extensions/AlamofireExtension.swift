
//  AlamofireExtension.swift
//  Serializable
//
//  Created by Kasper Welner on 08/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Alamofire

public struct Parser {
    public static let APICallSucceededNotification = "APICallSucceededNotification"
}

public extension Parser {
    
    /**
     Parse any generic object using the parsing handler.
     */
    
    internal static func serializer<T>(parsingHandler: (( data: AnyObject? ) -> T?)?) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer<T, NSError> { (request, response, data, error) -> Result<T, NSError> in
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case let .success(value):
                if let parsedObject: T = parsingHandler?( data: value ) {
                    NotificationCenter.default().post(name: Notification.Name(rawValue: APICallSucceededNotification), object: nil)
                    return .success(parsedObject)
                } else {
                    return .failure(NSError(domain: "Serializable.Parser", code: 2048, userInfo: [ NSLocalizedDescriptionKey : "Parsing block failed!", "JSONResponse" : value]))
                }
                
            case let .failure(error):
                if let data = data where data.count != 0 {
                    var userInfo = error.userInfo
                    userInfo["ResponseString"] = String(data: data, encoding: String.Encoding.utf8)
                    let newError = NSError(domain: error.domain, code: error.code, userInfo: userInfo)
                    return .failure(newError)
                }

                return .failure(error)
            }
        }
    }
    
    typealias Unwrapper = ((sourceDictionary: NSDictionary, expectedType:Any) -> AnyObject?)
    
    /**
     The default unwrapper. Default implementation just passes data straight through. 
     */
    
    public static var defaultUnwrapper: Unwrapper = { $0.0 }
}


//MARK: - Wrapper methods

public extension Alamofire.Request
{
    /**
     Adds a handler that attempts to parse the result of the request into a **Decodable**
     
     - parameter completionHandler:A closure that is invoked when the request is finished
     
     - parameter unwrapper: A closure that extracts the data to be parsed from the JSON response data.
     The default implementation checks for a "data" field in the JSON response, then checks for a field
     with the same name as the target model. If not found, it passes the JSON response straight through.
     
     - returns: The request
     */
    
    @discardableResult
    public func responseSerializable<T:Decodable>(_ completionHandler: (Response<T, NSError>) -> Void, unwrapper:Parser.Unwrapper = Parser.defaultUnwrapper) -> Self {
        let serializer = Parser.serializer(parsingHandler: {
            ( data: AnyObject? ) -> T? in
            
            if let sourceDictionary = data as? [String : AnyObject] {
                
                let unwrappedDictionary = unwrapper(sourceDictionary: sourceDictionary, expectedType:T.self) as? [String : AnyObject] ?? sourceDictionary
                
                return T(dictionary: unwrappedDictionary) as T?
            }
            
            return nil
        })
        
        return validate().response(responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    /**
     Adds a handler that attempts to parse the result of the request into an array of **Decodable**
     
     - parameter completionHandler:A closure that is invoked when the request is finished
     
     - parameter unwrapper: A closure that extracts the data to be parsed from the JSON response data.
     The default implementation checks for a "data" field in the JSON response, then checks for a field
     with the same name as the target model. If not found, it passes the JSON response straight through.
     
     - returns: The request
     */
    
    @discardableResult
    public func responseSerializable<T:Decodable>(_ completionHandler: (Response<[T], NSError>) -> Void, unwrapper:Parser.Unwrapper = Parser.defaultUnwrapper) -> Self {
        
        let serializer = Parser.serializer(parsingHandler: {
            ( data: AnyObject? ) -> [T]? in
            
            var finalArray:AnyObject? = data
            
            if let dataDict = data as? NSDictionary {
                if let unwrappedArray = unwrapper(sourceDictionary: dataDict, expectedType:T.self) as? NSArray {
                    finalArray = unwrappedArray
                }
            }
            
            if let sourceArray = finalArray as? NSArray {
                return T.array(sourceArray)
            }
            return nil
        })
        
        return validate().response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}
