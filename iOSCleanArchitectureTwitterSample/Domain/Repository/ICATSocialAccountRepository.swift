//
//  ICATSocialAccountRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol ICATSocialAccountRepository {
    func getTwitterAccountsTask() -> Observable<[ACAccount]>
}

// MARK: - Implementation
struct ICATSocialAccountRepositoryImpl: ICATSocialAccountRepository {
    private let dataStore: ICATSocialAccountDataStore
    
    public init(dataStore: ICATSocialAccountDataStore) {
        self.dataStore = dataStore
    }
    
    func getTwitterAccountsTask() -> Observable<[ACAccount]> {
        return dataStore.getTwitterAccounts()
    }
}
