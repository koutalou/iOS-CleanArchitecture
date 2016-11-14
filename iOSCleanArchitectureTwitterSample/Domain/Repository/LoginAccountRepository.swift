//
//  LoginUserRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol LoginAccountRepository {
    func getSelectedTwitterAccount() -> Observable<String?>
    func updateSelecteTwitterAccount(_ account: ACAccount) -> Observable<Void>
    func deleteTwitterAccount() -> Observable<Void>
}

// MARK: - Implementation
struct LoginAccountRepositoryImpl: LoginAccountRepository {
    private let dataStore: LoginAccountDataStore
    
    public init(dataStore: LoginAccountDataStore) {
        self.dataStore = dataStore
    }
    
    func getSelectedTwitterAccount() -> Observable<String?> {
        return dataStore.getSelectedTwitterAccountId()
    }
    
    func updateSelecteTwitterAccount(_ account: ACAccount) -> Observable<Void> {
        return dataStore.updateSelectedTwitterAccountId(account)

    }
    
    func deleteTwitterAccount() -> Observable<Void> {
        return dataStore.deleteSelectedTwitterAccountId()
    }
}
