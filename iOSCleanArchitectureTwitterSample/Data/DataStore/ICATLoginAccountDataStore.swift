//
//  ICATLoginAccountDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol ICATLoginAccountDataStore {
    func getSelectedTwitterAccountId() -> Observable<String?>
    func updateSelectedTwitterAccountId(_ account: ACAccount) -> Observable<Void>
    func deleteSelectedTwitterAccountId() -> Observable<Void>
}

// MARK: - Implementation
struct ICATLoginAccountDataStoreImpl: ICATLoginAccountDataStore {
    let ICAT_LOGIN_USER_ID: String = "ICAT_LOGIN_USER_ID"
    
    func getSelectedTwitterAccountId() -> Observable<String?> {
        let identifier = UserDefaults.standard.object(forKey: ICAT_LOGIN_USER_ID) as? String
        return Observable.just(identifier)
    }
    
    func updateSelectedTwitterAccountId(_ account: ACAccount) -> Observable<Void> {
        UserDefaults.standard.set(account.identifier, forKey: ICAT_LOGIN_USER_ID)
        UserDefaults.standard.synchronize()
        return Observable.just()
    }
    
    func deleteSelectedTwitterAccountId() -> Observable<Void> {
        UserDefaults.standard.removeObject(forKey: ICAT_LOGIN_USER_ID)
        UserDefaults.standard.synchronize()
        return Observable.just()
    }
}
