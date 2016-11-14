//
//  TimelineModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

struct TimelinesModel {
    var timelines: [TimelineModel] = []
}

struct TimelineModel {
    let name: String
    let screenName: String
    let profileUrl: String
    let tweet: String
    
    init(rowTimelineModel: TimelineEntity) {
        name = rowTimelineModel.user?.name ?? ""
        screenName = rowTimelineModel.user?.screenName ?? ""
        profileUrl = rowTimelineModel.user?.prifileUrl ?? ""
        tweet = rowTimelineModel.text
    }
}
