//
//  Repository.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Repository: Mappable {
    
    var id: Int = 0
    var name: String?
    var owner: Owner?
    var forksCount: Int = 0
    var watchersCount: Int = 0
    var issuesCount: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        owner <- map["owner"]
        forksCount <- map["forks_count"]
        watchersCount <- map["watchers_count"]
        issuesCount <- map["open_issues_count"]
    }
    
}

extension Repository: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return id
    }
}

func == (lhs: Repository, rhs: Repository) -> Bool {
    return (lhs.id == rhs.id)
}
