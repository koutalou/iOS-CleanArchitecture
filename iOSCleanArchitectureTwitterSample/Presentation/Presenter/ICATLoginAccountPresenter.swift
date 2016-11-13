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

protocol ICATLoginAccountPresenter {
    func loadAccounts()
    func selectAccount(_ index: Int)
    func tapCancel()
    func tapReload()
}

class ICATLoginAccountPresenterImpl: ICATLoginAccountPresenter {
    
    weak var viewInput: ICATLoginAccountViewInput?
    weak var wireframe: LoginAccountWireframe?
    var accountsModel: ICATRegisteredAccountsModel?
    var useCase: ICATLoginAccountUseCase
    
    private let disposeBag = DisposeBag()
    
    public required init(useCase: ICATLoginAccountUseCase, viewInput: ICATLoginAccountViewInput, wireframe: LoginAccountWireframe) {
        self.useCase = useCase
        self.viewInput = viewInput
        self.wireframe = wireframe
    }
    
    func loadAccounts() {
        useCase.loadAccounts()
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
        
        useCase.selectAccount(selectAccount)
            .subscribe(
                onNext: { [weak self] accounts in
                    self?.selectedAccount()
                }, onError: { [weak self] error in
                    self?.errorHandling(error: error)
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
    func tapCancel() {
        wireframe?.closeView()
    }
    
    func tapReload() {
        loadAccounts()
    }
}

// MARK: Private
extension ICATLoginAccountPresenterImpl {

    fileprivate func loadedAccountsModel(accounts: ICATRegisteredAccountsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.accountsModel = accounts
            self?.viewInput?.setAccountsModel(accounts)
            let isNoData: Bool = accounts.accounts.count == 0
            self?.viewInput?.changedStatus(isNoData ? ICATLoginAccountStatus.none : ICATLoginAccountStatus.normal)
        }
    }
    
    fileprivate func selectedAccount() {
        DispatchQueue.main.async { [weak self] in
            self?.wireframe?.closeView()
        }
    }
    
    fileprivate func errorHandling(error: Error) {
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
