//
//  ICATLoginUserDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import UIKit
import Accounts

class ICATSocialAccountDataStore: NSObject {
    
    func getTwitterAccounts(callback: (Array<ACAccount>, ICATError) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (authorized, error) -> Void in
            if (error != nil) {
                // Error
                callback([], ICATError.Generic)
                return
            }
            
            if (!authorized) {
                // Not Authorized
                callback([], ICATError.NotAuthorized)
                return
            }
            
            // Authorized
            let accounts = accountStore.accountsWithAccountType(accountType) as? Array<ACAccount> ?? []
            callback(accounts, ICATError.NoError)
        }
    }
}