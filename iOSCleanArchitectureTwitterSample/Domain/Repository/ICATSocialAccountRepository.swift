//
//  ICATSocialAccountRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import SwiftTask
import Accounts

class ICATSocialAccountRepository: NSObject {
    lazy var dataStore: ICATSocialAccountDataStore = ICATSocialAccountDataStore()

    func getTwitterAccountsTask() -> Task<Void, Array<ACAccount>?, ICATError> {
        return Task { _,fulfill, reject, configure in
            self.dataStore.getTwitterAccounts({ (accounts, error) -> Void in
                if (error.isError) {
                    reject(error)
                    return
                }
                
                fulfill(accounts)
            })
        }
    }
}