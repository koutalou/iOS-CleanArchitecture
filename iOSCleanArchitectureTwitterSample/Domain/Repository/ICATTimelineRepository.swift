//
//  ICATTimelineRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol ICATTimelineRepository {
    func getTwitterTimelineTask(_ account: ACAccount) -> Observable<[ICATTimelineEntity]>
}

// MARK: - Implementation
class ICATTimelineRepositoryImpl: ICATTimelineRepository {
    private let dataStore: ICATTimelineDataStore

    public init(dataStore: ICATTimelineDataStore) {
        self.dataStore = dataStore
    }

    func getTwitterTimelineTask(_ account: ACAccount) -> Observable<[ICATTimelineEntity]> {
        return dataStore.getTimelines(account)
    }
}
