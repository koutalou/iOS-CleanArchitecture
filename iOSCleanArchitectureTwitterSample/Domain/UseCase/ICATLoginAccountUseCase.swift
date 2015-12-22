//
//  ICATLoginUserUseCase.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import SwiftTask
import Accounts

protocol ICATLoginAccountUseCaseOutput: class {
    func loadTwitterAccounts(accountModel: ICATRegisteredAccountsModel)
    func loadTwitterAccountsErorr(error:ICATError)
    func resultSelectAccount(isSuccess: Bool)
}

class ICATLoginAccountUseCase: NSObject {
    weak var output: ICATLoginAccountUseCaseOutput?
    lazy var loginAccountRepository: ICATLoginAccountRepository = ICATLoginAccountRepository()
    lazy var socialAccountRepository: ICATSocialAccountRepository = ICATSocialAccountRepository()
    
    var acAccounts: Array<ACAccount>! = nil
    
    func loadAccounts() {
        var twitterAccountIdentifier: String?
        
        loginAccountRepository.getSelectedTwitterAccountTask().success { (identifier) -> Task<Void, Array<ACAccount>?, ICATError> in
            twitterAccountIdentifier = identifier
            return self.socialAccountRepository.getTwitterAccountsTask()
        }
        .success { (accounts) -> Void in
            self.acAccounts = accounts!
            let registeredAccountsModel = ICATRegisteredAccountTranslater.generateRegisteredAccount(accounts!, selectedIdentifier: twitterAccountIdentifier)
            self.output?.loadTwitterAccounts(registeredAccountsModel)
        }
        .failure { (error, isCancelled) -> Void in
            self.output?.loadTwitterAccountsErorr(error ?? ICATError.Generic)
        }
    }
    
    func selectAccount(account: ICATRegisteredAccountModel) {
        guard let acAccount = acAccounts.filter({ $0.identifier == account.identifier}).first else {
            output?.resultSelectAccount(false)
            return
        }
        
        loginAccountRepository.updateSelecteTwitterAccountTask(acAccount).success {
            self.output?.resultSelectAccount(true)
        }
        .failure { _,_ in
            self.output?.resultSelectAccount(false)
        }
    }
}