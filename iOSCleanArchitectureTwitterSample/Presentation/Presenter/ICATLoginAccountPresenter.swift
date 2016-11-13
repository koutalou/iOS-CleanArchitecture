//
//  ICATLoginUserPresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

enum ICATLoginAccountStatus {
    case none
    case normal
    case notAuthorized
    case error
}

class ICATLoginAccountPresenter {
    
    weak var viewInput: ICATLoginAccountViewInput?
    var accountsModel: ICATRegisteredAccountsModel?
    var usecase: ICATLoginAccountUseCase = ICATLoginAccountUseCase()
    
    private let disposeBag = DisposeBag()
    
    func loadAccounts() {
        usecase.loadAccounts()
            .subscribe(
                onNext: { [weak self] accounts in
                    self?.loadedAccountsModel(accounts: accounts)
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    func selectAccount(_ index: Int) {
        guard let accountsModel = accountsModel else {
            // Not loaded yet
            return
        }
        let selectAccount: ICATRegisteredAccountModel = accountsModel.accounts[index]
        
        usecase.selectAccount(selectAccount)
            .subscribe(
                onNext: { [weak self] accounts in
                    self?.selectedAccount()
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    private func loadedAccountsModel(accounts: ICATRegisteredAccountsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.accountsModel = accounts
            self?.viewInput?.setAccountsModel(accounts)
            let isNoData: Bool = accounts.accounts.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATLoginAccountStatus.none : ICATLoginAccountStatus.normal)
        }
    }
    
    private func selectedAccount() {
        DispatchQueue.main.async { [weak self] in
            self?.viewInput?.closeView()
        }
    }
    
    private func errorHandling(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let error = error as? ICATError else {
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.error)
                return
            }
            switch error {
            case .notAuthorized:
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.notAuthorized)
            default:
                self?.viewInput?.changedStatus(ICATLoginAccountStatus.error)
            }
        }
    }
}
