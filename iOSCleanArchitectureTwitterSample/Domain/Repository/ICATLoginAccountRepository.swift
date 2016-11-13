//
//  ICATLoginUserRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol ICATLoginAccountRepository {
    func getSelectedTwitterAccountTask() -> Observable<String?>
    func updateSelecteTwitterAccountTask(_ account: ACAccount) -> Observable<Void>
    func deleteTwitterAccount() -> Observable<Void>
}

// MARK: - Implementation
struct ICATLoginAccountRepositoryImpl: ICATLoginAccountRepository {
    private let dataStore: ICATLoginAccountDataStore
    
    public init(dataStore: ICATLoginAccountDataStore) {
        self.dataStore = dataStore
    }
    
    func getSelectedTwitterAccountTask() -> Observable<String?> {
        return dataStore.getSelectedTwitterAccountId()
    }
    
    func updateSelecteTwitterAccountTask(_ account: ACAccount) -> Observable<Void> {
        return dataStore.updateSelectedTwitterAccountId(account)

    }
    
    func deleteTwitterAccount() -> Observable<Void> {
        return dataStore.deleteSelectedTwitterAccountId()
    }
}
