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

protocol ICATLoginAccountUseCaseOutput: class {
    func loadTwitterAccounts() -> Observable<ICATRegisteredAccountsModel>
    func selectAccount(_ account: ICATRegisteredAccountModel) -> Observable<Void>
}

class ICATLoginAccountUseCase: NSObject {
    weak var output: ICATLoginAccountUseCaseOutput?
    lazy var loginAccountRepository: ICATLoginAccountRepository = ICATLoginAccountRepository()
    lazy var socialAccountRepository: ICATSocialAccountRepository = ICATSocialAccountRepository()
    
    var acAccounts: [ACAccount] = []
    
    func loadAccounts() -> Observable<ICATRegisteredAccountsModel> {
        let login = loginAccountRepository.getSelectedTwitterAccountTask()
        let accounts = socialAccountRepository.getTwitterAccountsTask()
        
        return Observable.combineLatest(accounts, login) { ($0, $1) }
            .flatMap { (accounts, identifier) -> Observable<ICATRegisteredAccountsModel> in
                self.acAccounts = accounts
                return Observable.just((accounts, identifier))
                    .map(translator: ICATRegisteredAccountTranslater())
        }
    }
    
    func selectAccount(_ account: ICATRegisteredAccountModel) -> Observable<Void> {
        guard let acAccount = acAccounts.filter({ $0.identifier.isEqual(to: account.identifier)}).first else {
            return Observable.error(ICATError.generic)
        }
        return loginAccountRepository.updateSelecteTwitterAccountTask(acAccount)
    }
}
