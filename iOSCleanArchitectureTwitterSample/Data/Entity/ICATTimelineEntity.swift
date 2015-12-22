//
//  ICATTimelineEntity.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ICATTimelineEntity: Object,Mappable {
    dynamic var text = ""
    dynamic var createdAt = ""
    dynamic var user: ICATUserEntity? = nil
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        createdAt <- map["created_at"]
        user <- map["user"]
    }
}

class ICATUserEntity: Object, Mappable {
    dynamic var screenName = ""
    dynamic var prifileUrl = ""
    dynamic var name = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        screenName <- map["screen_name"]
        prifileUrl <- map["profile_image_url_https"]
        name <- map["name"]
    }
}