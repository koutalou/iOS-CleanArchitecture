//
//  ICATTimelineTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

class ICATTimelineTranslater: NSObject {
    
    class func generateTimelines(rowTimelines: Array<ICATTimelineEntity>) -> ICATTimelinesModel {
        let timelinesModel: ICATTimelinesModel = ICATTimelinesModel()
        rowTimelines.forEach { rowTimeline -> () in
            let timelineModel = ICATTimelineModel(rowTimelineModel: rowTimeline)
            timelinesModel.timelines.append(timelineModel)
        }
        
        return timelinesModel
    }
}