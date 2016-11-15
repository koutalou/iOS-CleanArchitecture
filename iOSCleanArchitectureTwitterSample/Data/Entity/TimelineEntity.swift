//
//  TimelineEntity.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class TimelineEntity: Object,Mappable {
    var text = ""
    var createdAt = ""
    dynamic var user: UserEntity? = nil
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        text <- map["text"]
        createdAt <- map["created_at"]
        user <- map["user"]
    }
}

public class UserEntity: Object, Mappable {
    var screenName = ""
    var userDescription = ""
    var profileUrl = ""
    var profileBackgroundUrl = ""
    var name = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        screenName <- map["screen_name"]
        userDescription <- map["description"]
        profileUrl <- map["profile_image_url_https"]
        profileBackgroundUrl <- map["profile_background_image_url_https"]
        name <- map["name"]
    }
}
