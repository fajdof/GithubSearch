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
    var updatedAt: Date?
    var starsCount: Int = 0
    var language: String?
    var hasWiki: Bool = false
    var defaultBranch: String?
    var repositoryUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            if let dateString = value {
                return formatter.date(from: dateString)
            }
            return nil
        }, toJSON: { (value: Date?) -> String? in
            if let date = value {
                return formatter.string(from: date)
            }
            return nil
        })
        
        id <- map["id"]
        name <- map["name"]
        owner <- map["owner"]
        forksCount <- map["forks_count"]
        watchersCount <- map["watchers_count"]
        issuesCount <- map["open_issues_count"]
        updatedAt <- (map["pushed_at"], dateTransform)
        starsCount <- map["stargazers_count"]
        language <- map["language"]
        hasWiki <- map["has_wiki"]
        defaultBranch <- map["default_branch"]
        repositoryUrl <- map["html_url"]
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
