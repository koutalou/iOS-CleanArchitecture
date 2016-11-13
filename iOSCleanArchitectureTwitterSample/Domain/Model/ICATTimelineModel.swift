//
//  ICATTimelineModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

struct ICATTimelinesModel {
    var timelines: [ICATTimelineModel] = []
}

struct ICATTimelineModel {
    var name: String = ""
    var screenName: String = ""
    var profileUrl: String = ""
    var tweet: String = ""
    
    init(rowTimelineModel: ICATTimelineEntity) {
        name = rowTimelineModel.user?.name ?? ""
        screenName = rowTimelineModel.user?.screenName ?? ""
        profileUrl = rowTimelineModel.user?.prifileUrl ?? ""
        tweet = rowTimelineModel.text
    }
}
