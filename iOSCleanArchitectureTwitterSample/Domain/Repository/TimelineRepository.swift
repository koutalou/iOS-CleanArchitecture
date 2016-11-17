//
//  TimelineRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol TimelineRepository {
    func getTwitterTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]>
    func getTwitterUserTimelines(_ account: ACAccount, screenName: String) -> Observable<[TimelineEntity]>
}

// MARK: - Implementation
struct TimelineRepositoryImpl: TimelineRepository {
    private let dataStore: TimelineDataStore

    public init(dataStore: TimelineDataStore) {
        self.dataStore = dataStore
    }

    func getTwitterTimelines(_ account: ACAccount) -> Observable<[TimelineEntity]> {
        return dataStore.getHomeTimelines(account)
    }
    
    func getTwitterUserTimelines(_ account: ACAccount, screenName: String) -> Observable<[TimelineEntity]> {
        return dataStore.getUserTimelines(account, screenName: screenName)
    }
}
