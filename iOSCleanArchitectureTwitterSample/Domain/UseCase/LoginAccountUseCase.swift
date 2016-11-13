//
//  LoginUserUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

protocol LoginAccountUseCase {
    func loadAccounts() -> Observable<RegisteredAccountsModel>
    func selectAccount(_ account: RegisteredAccountModel) -> Observable<Void>
}

struct LoginAccountUseCaseImpl: LoginAccountUseCase {
    private let loginAccountRepository: LoginAccountRepository
    private let socialAccountRepository: SocialAccountRepository
    
    var acAccounts: [ACAccount] = []
    
    public init(loginAccountRepository: LoginAccountRepository, socialAccountRepository: SocialAccountRepository) {
        self.loginAccountRepository = loginAccountRepository
        self.socialAccountRepository = socialAccountRepository
    }
    
    func loadAccounts() -> Observable<RegisteredAccountsModel> {
        let login = loginAccountRepository.getSelectedTwitterAccountTask()
        let accounts = socialAccountRepository.getTwitterAccountsTask()
        
        return Observable.combineLatest(accounts, login) { ($0, $1) }
            .flatMap { (accounts, identifier) -> Observable<RegisteredAccountsModel> in
                return Observable.just((accounts, identifier))
                    .map(translator: RegisteredAccountTranslater())
        }
    }
    
    func selectAccount(_ account: RegisteredAccountModel) -> Observable<Void> {
        return socialAccountRepository.getTwitterAccountsTask()
            .flatMap { accounts -> Observable<Void> in
                guard let acAccount = accounts.filter({ $0.identifier.isEqual(to: account.identifier)}).first else {
                    return Observable.error(AppError.generic)
                }
                return self.loginAccountRepository.updateSelecteTwitterAccountTask(acAccount)
        }
    }
}
