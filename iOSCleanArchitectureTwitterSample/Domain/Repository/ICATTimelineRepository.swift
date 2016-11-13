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

class ICATTimelineRepository: NSObject {
    lazy var dataStore: ICATTimelineDataStore = ICATTimelineDataStore()

    func getTwitterTimelineTask(_ account: ACAccount) -> Observable<[ICATTimelineEntity]> {
        return dataStore.getTimelines(account)
    }
}
