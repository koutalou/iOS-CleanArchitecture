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

class ICATSocialAccountRepository: NSObject {
    lazy var dataStore: ICATSocialAccountDataStore = ICATSocialAccountDataStore()

    func getTwitterAccountsTask() -> Observable<[ACAccount]> {//Task<Void, Array<ACAccount>?, ICATError> {
        return dataStore.getTwitterAccounts()
    }
}
