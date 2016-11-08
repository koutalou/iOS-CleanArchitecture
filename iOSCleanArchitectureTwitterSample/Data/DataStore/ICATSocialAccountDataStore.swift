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
    
    func getTwitterAccounts(_ callback: @escaping (Array<ACAccount>, ICATError) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (authorized, error) -> Void in
            if (error != nil) {
                // Error
                callback([], ICATError.generic)
                return
            }
            
            if (!authorized) {
                // Not Authorized
                callback([], ICATError.notAuthorized)
                return
            }
            
            // Authorized
            let accounts = accountStore.accounts(with: accountType) as? Array<ACAccount> ?? []
            callback(accounts, ICATError.noError)
        }
    }
}
