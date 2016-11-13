//
//  ICATTimelineDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

class ICATTimelineDataStore: NSObject {
    let request: ICATRestSLRequest = ICATRestSLRequest()
    
    func getTimelines(_ account: ACAccount) -> Observable<[ICATTimelineEntity]> {
        return request.getTimeline(account)
    }
}
