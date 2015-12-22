//
//  ICATLoginUserPresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

enum ICATLoginAccountStatus {
    case None
    case Normal
    case NotAuthorized
    case Error
}

class ICATLoginAccountPresenter: NSObject, ICATLoginAccountUseCaseOutput {
    
    weak var viewInput: ICATLoginAccountViewInput?
    var accountsModel: ICATRegisteredAccountsModel?
    var usecase: ICATLoginAccountUseCase = ICATLoginAccountUseCase()
    
    func loadAccounts() {
        usecase.output = self
        usecase.loadAccounts()
    }
    
    func selectAccount(index: Int) {
        if (accountsModel?.accounts.count <= index) {
            // Error
            return
        }
        
        let selectAccount: ICATRegisteredAccountModel = accountsModel!.accounts[index]
        usecase.selectAccount(selectAccount)
    }
    
    // MARK: ICATLoginAccountUseCaseOutput
    
    func loadTwitterAccounts(registeredAccountsModel: ICATRegisteredAccountsModel) {
        accountsModel = registeredAccountsModel
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            self?.viewInput?.setAccountsModel(self!.accountsModel!)
            let isNoData: Bool = self!.accountsModel!.accounts.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATLoginAccountStatus.None : ICATLoginAccountStatus.Normal)
        }
    }
    
    func loadTwitterAccountsErorr(error: ICATError) {
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            if (error == .NotAuthorized) {
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.NotAuthorized)
            } else {
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.Error)
            }
        }
    }
    
    func resultSelectAccount(isSuccess: Bool) {
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            self?.viewInput?.selectAccountResult(isSuccess)
        }
    }

}