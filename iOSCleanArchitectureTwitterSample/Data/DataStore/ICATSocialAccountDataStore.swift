//
//  ICATLoginUserDataStore.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Accounts

// MARK: - Interface
public protocol ICATSocialAccountDataStore {
    func getTwitterAccounts() -> Observable<[ACAccount]>
}

// MARK: - Implementation
struct ICATSocialAccountDataStoreImpl: ICATSocialAccountDataStore {
    
    func getTwitterAccounts() -> Observable<[ACAccount]> {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        return Observable.create { observer in
            accountStore.requestAccessToAccounts(with: accountType, options: nil) { (authorized, error) -> Void in
                if (error != nil) {
                    // Generic Error
                    observer.onError(ICATError.generic)
                    return
                }
                
                if (!authorized) {
                    // Not Authorized
                    observer.onError(ICATError.notAuthorized)
                    return
                }
                
                // Authorized
                let accounts = accountStore.accounts(with: accountType) as? Array<ACAccount> ?? []
                observer.onNext(accounts)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
