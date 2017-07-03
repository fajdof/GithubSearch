//
//  SearchResult.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class SearchResult: Mappable {
    
    var repositories: [Repository] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        repositories <- map["items"]
    }
    
}
