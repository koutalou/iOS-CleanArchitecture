//
//  ICATLoginUserRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import SwiftTask
import Accounts

class ICATLoginAccountRepository: NSObject {
    lazy var dataStore: ICATLoginAccountDataStore = ICATLoginAccountDataStore()
    
    class var sharedInstance: ICATLoginAccountRepository
    {
        struct Static {
            static var instance: ICATLoginAccountRepository!
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = ICATLoginAccountRepository()
        }
        return Static.instance
    }
    
    func getSelectedTwitterAccountTask() -> Task<Void, String?, ICATError> {
        return Task { _,fulfill, reject, configure in
            self.dataStore.getSelectedTwitterAccountId({ (accountIdentifier, error) -> Void in
                if (error.isError) {
                    reject(error)
                    return
                }
                
                fulfill(accountIdentifier)
            })
        }
    }
    
    func updateSelecteTwitterAccountTask(account: ACAccount) -> Task<Void, Void, ICATError> {
        return Task { _,fulfill, reject, configure in
            self.dataStore.updateSelectedTwitterAccountId(account, callback: { (error) -> Void in
                if (error.isError) {
                    reject(error)
                    return
                }
                
                fulfill()
            })
        }
    }
    
    func deleteTwitterAccount() {
        dataStore.deleteSelectedTwitterAccountId()
    }
}