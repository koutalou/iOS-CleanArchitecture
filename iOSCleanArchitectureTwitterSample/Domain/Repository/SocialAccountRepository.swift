//
//  SocialAccountRepository.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

// MARK: - Interface
public protocol SocialAccountRepository {
    func getTwitterAccounts() -> Observable<[ACAccount]>
}

// MARK: - Implementation
struct SocialAccountRepositoryImpl: SocialAccountRepository {
    private let dataStore: SocialAccountDataStore
    
    public init(dataStore: SocialAccountDataStore) {
        self.dataStore = dataStore
    }
    
    func getTwitterAccounts() -> Observable<[ACAccount]> {
        return dataStore.getTwitterAccounts()
    }
}
