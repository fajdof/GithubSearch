//
//  BaseViewModel.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/17.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseViewModel {
	var navigationService: NavigationService! { get set }

	init()

	func extractedError(data: Any) -> RequestError
}

extension BaseViewModel {

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

}
