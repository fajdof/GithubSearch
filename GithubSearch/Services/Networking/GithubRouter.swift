//
//  GithubRouter.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Alamofire

enum GithubRouter: URLRequestConvertible, AlamofireRouter {
    
    static let baseURLString = "https://api.github.com"
    
    case Get(path: String, params: [String: AnyObject]?)
    
    var method: HTTPMethod {
        switch self {
        case .Get(_, _):
            return HTTPMethod.get
        }
    }
    
    var params: [String: AnyObject]? {
        switch self {
        case .Get(_, let params):
            return params
        }
    }
    
    var url: URL {
        
        switch self {
        case .Get(let path, _):
            return URL(string: GithubRouter.baseURLString + path)!
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: params)
    }
    
}
