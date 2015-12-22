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
    
    func deleteTwitterAccount() -> Task<Void, Void, ICATError> {
        return Task { _,fulfill, reject, configure in
            self.dataStore.deleteSelectedTwitterAccountId({ (error) -> Void in
                if (error.isError) {
                    reject(error)
                    return
                }
                
                fulfill()
            })
        }
    }
}