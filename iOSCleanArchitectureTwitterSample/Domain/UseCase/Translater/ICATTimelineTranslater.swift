//
//  ICATTimelineTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

struct ICATTimelineTranslater: Translator {
    typealias Input = [ICATTimelineEntity]
    typealias Output = ICATTimelinesModel
    
    func translate(_ entity: [ICATTimelineEntity]) throws -> ICATTimelinesModel {
        var timelinesModel: ICATTimelinesModel = ICATTimelinesModel()
        entity.forEach { rowTimeline -> () in
            let timelineModel = ICATTimelineModel(rowTimelineModel: rowTimeline)
            timelinesModel.timelines.append(timelineModel)
        }
        return timelinesModel
    }
}
