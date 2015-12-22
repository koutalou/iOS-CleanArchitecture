//
//  ICATTimelineModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

class ICATTimelinesModel: NSObject {
    var timelines: [ICATTimelineModel] = []
}

class ICATTimelineModel: NSObject {
    var name: String = ""
    var screenName: String = ""
    var profileUrl: String = ""
    var tweet: String = ""
    
    required init(rowTimelineModel: ICATTimelineEntity) {
        super.init()
        name = rowTimelineModel.user?.name ?? ""
        screenName = rowTimelineModel.user?.screenName ?? ""
        profileUrl = rowTimelineModel.user?.prifileUrl ?? ""
        tweet = rowTimelineModel.text
    }
}