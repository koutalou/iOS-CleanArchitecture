//
//  TimelineDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol TimelineDataStore {
    func getTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]>
}

// MARK: - Implementation
class TimelineDataStoreImpl: TimelineDataStore {
    let request: RestSLRequest = RestSLRequest()
    
    func getTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]> {
        return request.getTimeline(account)
    }
}
