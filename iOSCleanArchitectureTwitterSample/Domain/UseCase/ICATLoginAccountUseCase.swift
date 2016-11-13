//
//  ICATLoginUserUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

protocol ICATLoginAccountUseCase {
    func loadAccounts() -> Observable<ICATRegisteredAccountsModel>
    func selectAccount(_ account: ICATRegisteredAccountModel) -> Observable<Void>
}

struct ICATLoginAccountUseCaseImpl: ICATLoginAccountUseCase {
    private let loginAccountRepository: ICATLoginAccountRepository
    private let socialAccountRepository: ICATSocialAccountRepository
    
    var acAccounts: [ACAccount] = []
    
    public init(loginAccountRepository: ICATLoginAccountRepository, socialAccountRepository: ICATSocialAccountRepository) {
        self.loginAccountRepository = loginAccountRepository
        self.socialAccountRepository = socialAccountRepository
    }
    
    func loadAccounts() -> Observable<ICATRegisteredAccountsModel> {
        let login = loginAccountRepository.getSelectedTwitterAccountTask()
        let accounts = socialAccountRepository.getTwitterAccountsTask()
        
        return Observable.combineLatest(accounts, login) { ($0, $1) }
            .flatMap { (accounts, identifier) -> Observable<ICATRegisteredAccountsModel> in
                return Observable.just((accounts, identifier))
                    .map(translator: ICATRegisteredAccountTranslater())
        }
    }
    
    func selectAccount(_ account: ICATRegisteredAccountModel) -> Observable<Void> {
        return socialAccountRepository.getTwitterAccountsTask()
            .flatMap { accounts -> Observable<Void> in
                guard let acAccount = accounts.filter({ $0.identifier.isEqual(to: account.identifier)}).first else {
                    return Observable.error(ICATError.generic)
                }
                return self.loginAccountRepository.updateSelecteTwitterAccountTask(acAccount)
        }
    }
}
