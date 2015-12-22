//
//  ICATLoginAccountDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

class ICATLoginAccountDataStore: NSObject {
    let ICAT_LOGIN_USER_ID: String = "ICAT_LOGIN_USER_ID"
    
    func getSelectedTwitterAccountId(callback: (String?, ICATError) -> Void) {
        let identifier: String? = NSUserDefaults.standardUserDefaults().objectForKey(ICAT_LOGIN_USER_ID) as? String
        callback(identifier, ICATError.NoError)
    }
    
    func updateSelectedTwitterAccountId(account: ACAccount, callback: (ICATError) -> Void) {
        NSUserDefaults.standardUserDefaults().setObject(account.identifier, forKey: ICAT_LOGIN_USER_ID)
        NSUserDefaults.standardUserDefaults().synchronize()
        callback(ICATError.NoError)
    }
    
    func deleteSelectedTwitterAccountId(callback: (ICATError) -> Void) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ICAT_LOGIN_USER_ID)
        NSUserDefaults.standardUserDefaults().synchronize()
        callback(ICATError.NoError)
    }
}