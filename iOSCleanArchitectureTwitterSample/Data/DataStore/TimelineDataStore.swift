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
    func getHomeTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]>
    func getUserTimelines(_ account: ACAccount, screenName: String) -> Observable<[TimelineEntity]>
}

// MARK: - Implementation
struct TimelineDataStoreImpl: TimelineDataStore {
    let request: RestSLRequest = RestSLRequest()
    
    func getHomeTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]> {
        return request.getHomeTimeline(account)
    }
    
    func getUserTimelines(_ account: ACAccount, screenName: String) -> Observable<[TimelineEntity]> {
        return request.getUserTimeline(account, screenName: screenName)
    }
}
