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
    
    func getSelectedTwitterAccountId(_ callback: (String?, ICATError) -> Void) {
        let identifier: String? = UserDefaults.standard.object(forKey: ICAT_LOGIN_USER_ID) as? String
        callback(identifier, ICATError.noError)
    }
    
    func updateSelectedTwitterAccountId(_ account: ACAccount, callback: (ICATError) -> Void) {
        UserDefaults.standard.set(account.identifier, forKey: ICAT_LOGIN_USER_ID)
        UserDefaults.standard.synchronize()
        callback(ICATError.noError)
    }
    
    func deleteSelectedTwitterAccountId(_ callback: (ICATError) -> Void) {
        UserDefaults.standard.removeObject(forKey: ICAT_LOGIN_USER_ID)
        UserDefaults.standard.synchronize()
        callback(ICATError.noError)
    }
}
