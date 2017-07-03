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
    
    var id: Int = 0
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}

extension SearchResult: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return id
    }
}

func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return (lhs.id == rhs.id)
}
