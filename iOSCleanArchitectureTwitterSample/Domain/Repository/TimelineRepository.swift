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
    func getTwitterTimelineTask(_ account: ACAccount) -> Observable<[TimelineEntity]>
}

// MARK: - Implementation
class TimelineRepositoryImpl: TimelineRepository {
    private let dataStore: TimelineDataStore

    public init(dataStore: TimelineDataStore) {
        self.dataStore = dataStore
    }

    func getTwitterTimelineTask(_ account: ACAccount) -> Observable<[TimelineEntity]> {
        return dataStore.getTimelines(account)
    }
}
