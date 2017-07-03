//
//  NetworkService.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

protocol AlamofireRouter {
	var method: HTTPMethod { get }
	var params: [String: AnyObject]? { get }
	var url: URL { get }
	var encoding: ParameterEncoding { get }
	var headers: [String: String]? { get }
}

struct NetworkService {

	func request(router : AlamofireRouter) -> Observable<(HTTPURLResponse, Any)> {
		return RxAlamofire.requestJSON(router.method, router.url, parameters: router.params, encoding: router.encoding, headers: router.headers).observeOn(MainScheduler.instance)
	}
    
    func getSearchResults(withQuery query: String, sortedBy scope: String) -> Observable<(HTTPURLResponse, Any)> {
        
        let params: [String: Any]? = [
            "q": query,
            "sort": scope
        ]
        
        return request(router: GithubRouter.Get(path: "/search/repositories", params: params as [String : AnyObject]?)).debug()
    }
    
    func getRepositoryDetails(withRepositoryId repositoryId: String) -> Observable<(HTTPURLResponse, Any)> {
        
        return request(router: GithubRouter.Get(path: "/repositories/\(repositoryId)", params: nil)).debug()
    }
}
