//
//  ICATTimelineRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import SwiftTask
import Accounts

class ICATTimelineRepository: NSObject {
    lazy var dataStore: ICATTimelineDataStore = ICATTimelineDataStore()

    func getTwitterTimelineTask(accoount: ACAccount) -> Task<Void, Array<ICATTimelineEntity>?, ICATError> {
        return Task { _,fulfill, reject, configure in
            self.dataStore.getTimelines(accoount, callback: { (timelines, error) -> Void in
                if (error.isError) {
                    reject(error)
                    return
                }
                
                fulfill(timelines)
            })
        }
    }
}