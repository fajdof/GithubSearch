//
//  Owner.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner: Mappable {
    
    var id: Int = 0
    var name: String?
    var avatarUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["login"]
        avatarUrl <- map["avatar_url"]
    }
    
}
