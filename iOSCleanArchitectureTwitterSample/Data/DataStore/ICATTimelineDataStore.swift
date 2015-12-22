//
//  ICATTimelineDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

class ICATTimelineDataStore: NSObject {
    let request: ICATRestSLRequest = ICATRestSLRequest()
    
    func getTimelines(account: ACAccount ,callback: (Array<ICATTimelineEntity>?, ICATError) -> Void) {
        request.getTimeline(account) { (timelines, error) -> Void in
            callback(timelines, ICATError.NoError)
        }
    }
}
