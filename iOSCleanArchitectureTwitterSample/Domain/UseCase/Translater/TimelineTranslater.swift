//
//  TimelineTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

struct TimelineTranslater: Translator {
    typealias Input = [TimelineEntity]
    typealias Output = TimelinesModel
    
    func translate(_ entity: [TimelineEntity]) throws -> TimelinesModel {
        var timelinesModel: TimelinesModel = TimelinesModel()
        entity.forEach { rowTimeline -> () in
            let timelineModel = TimelineModel(rowTimelineModel: rowTimeline)
            timelinesModel.timelines.append(timelineModel)
        }
        return timelinesModel
    }
}
