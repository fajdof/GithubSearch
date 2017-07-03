//
//  NetworkRequestHandler.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

protocol NetworkRequestHandler {
    
    var networkService: NetworkService! { get set }
    
    var successfulStatusCodes: CountableClosedRange<Int> { get }
    
    var defaultNetworkError: RequestError { get }
    
    func extractedError(data: Any) -> RequestError
    
    func parseJSONArray<T: Mappable>(data: Any) -> Result<[T]>
    
    func parseJSONAsTopLevelArray<T: Mappable>(data: Any, response: HTTPURLResponse) -> Result<[T]>
    
    func parseJSONDictionary<T: Mappable>(data: Any) -> Result<T>
    
    func parseJSONAsTopLevelDictionary<T: Mappable>(data: Any, response: HTTPURLResponse) -> Result<T>
}

extension NetworkRequestHandler {
    
    var successfulStatusCodes: CountableClosedRange<Int> {
        return (200 ... 299)
    }
    
    var defaultNetworkError: RequestError {
        return RequestError(message: "Network Error")
    }
    
    func extractedError(data: Any) -> RequestError {
        
        if let arrayData = data as? [[String: Any]] {
            if let error = Mapper<RequestError>().mapArray(JSONArray: arrayData).first {
                return error
            }
        }
        else if let dictData = data as? [String: Any] {
            if let error = RequestError(JSON: dictData) {
                return error
            }
        }
        
        return RequestError(JSON: ["message":"Network Error"])!
    }
    
    func parseJSONArray<T: Mappable>(data: Any) -> Result<[T]> {
        if let arrayData = data as? [[String: Any]] {
            let mappedData = Mapper<T>().mapArray(JSONArray: arrayData)
            return .success(mappedData)
        } else {
            return .failure(defaultNetworkError)
        }
    }
    
    func parseJSONAsTopLevelArray<T: Mappable>(data: Any, response: HTTPURLResponse) -> Result<[T]> {
        if successfulStatusCodes.contains(response.statusCode) {
            return parseJSONArray(data: data)
        } else {
            return .failure(extractedError(data: data))
        }
    }
    
    func parseJSONDictionary<T: Mappable>(data: Any) -> Result<T> {
        if let dictionaryData = data as? [String: AnyObject], let mappedData = T(JSON: dictionaryData) {
            return .success(mappedData)
        } else {
            return .failure(defaultNetworkError)
        }
    }
    
    func parseJSONAsTopLevelDictionary<T: Mappable>(data: Any, response: HTTPURLResponse) -> Result<T> {
        if successfulStatusCodes.contains(response.statusCode) {
            return parseJSONDictionary(data: data)
        } else {
            return .failure(extractedError(data: data))
        }
    }
    
}
