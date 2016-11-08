//
//  ICATLoginUserPresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


enum ICATLoginAccountStatus {
    case none
    case normal
    case notAuthorized
    case error
}

class ICATLoginAccountPresenter: NSObject, ICATLoginAccountUseCaseOutput {
    
    weak var viewInput: ICATLoginAccountViewInput?
    var accountsModel: ICATRegisteredAccountsModel?
    var usecase: ICATLoginAccountUseCase = ICATLoginAccountUseCase()
    
    func loadAccounts() {
        usecase.output = self
        usecase.loadAccounts()
    }
    
    func selectAccount(_ index: Int) {
        if (accountsModel?.accounts.count <= index) {
            // Error
            return
        }
        
        let selectAccount: ICATRegisteredAccountModel = accountsModel!.accounts[index]
        usecase.selectAccount(selectAccount)
    }
    
    // MARK: ICATLoginAccountUseCaseOutput
    
    func loadTwitterAccounts(_ registeredAccountsModel: ICATRegisteredAccountsModel) {
        accountsModel = registeredAccountsModel
        DispatchQueue.main.async { [weak self]() -> Void in
            self?.viewInput?.setAccountsModel(self!.accountsModel!)
            let isNoData: Bool = self!.accountsModel!.accounts.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATLoginAccountStatus.none : ICATLoginAccountStatus.normal)
        }
    }
    
    func loadTwitterAccountsErorr(_ error: ICATError) {
        DispatchQueue.main.async { [weak self]() -> Void in
            if (error == .notAuthorized) {
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.notAuthorized)
            } else {
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.error)
            }
        }
    }
    
    func resultSelectAccount(_ isSuccess: Bool) {
        DispatchQueue.main.async { [weak self]() -> Void in
            self?.viewInput?.selectAccountResult(isSuccess)
        }
    }

}
