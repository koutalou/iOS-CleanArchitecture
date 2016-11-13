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

class ICATLoginAccountRepository: NSObject {
    lazy var dataStore: ICATLoginAccountDataStore = ICATLoginAccountDataStore()
    
    func getSelectedTwitterAccountTask() -> Observable<String?> {//Task<Void, String?, ICATError> {
        return dataStore.getSelectedTwitterAccountId()
    }
    
    func updateSelecteTwitterAccountTask(_ account: ACAccount) -> Observable<Void> {
        return dataStore.updateSelectedTwitterAccountId(account)

    }
    
    func deleteTwitterAccount() -> Observable<Void> {
        return dataStore.deleteSelectedTwitterAccountId()
    }
}
