//
//  LoginUserPresenter.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import RxSwift
import Accounts

enum LoginAccountStatus {
    case none
    case normal
    case notAuthorized
    case error
}

protocol LoginAccountPresenter {
    func loadAccounts()
    func selectAccount(_ index: Int)
    func tapCancel()
    func tapReload()
}

class LoginAccountPresenterImpl: LoginAccountPresenter {
    
    weak var viewInput: LoginAccountViewInput?
    var wireframe: LoginAccountWireframe?
    var accountsModel: RegisteredAccountsModel?
    var useCase: LoginAccountUseCase
    
    fileprivate let observer: SelectPersonObserver
    private let disposeBag = DisposeBag()
    
    public required init(useCase: LoginAccountUseCase, viewInput: LoginAccountViewInput, wireframe: LoginAccountWireframe, observer: SelectPersonObserver) {
        self.useCase = useCase
        self.viewInput = viewInput
        self.wireframe = wireframe
        self.observer = observer
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
        let selectAccount: RegisteredAccountModel = accountsModel.accounts[index]
        
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
extension LoginAccountPresenterImpl {

    fileprivate func loadedAccountsModel(accounts: RegisteredAccountsModel) {
        DispatchQueue.main.async { [weak self] in
            self?.accountsModel = accounts
            self?.viewInput?.setAccountsModel(accounts)
            let isNoData: Bool = accounts.accounts.count == 0
            self?.viewInput?.changedStatus(isNoData ? LoginAccountStatus.none : LoginAccountStatus.normal)
        }
    }
    
    fileprivate func selectedAccount() {
        DispatchQueue.main.async { [weak self] in
            self?.wireframe?.closeView()
        }
        
        observer.selectPersonObserver.onNext()
    }
    
    fileprivate func errorHandling(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let error = error as? AppError else {
                self?.viewInput?.changedStatus(LoginAccountStatus.error)
                return
            }
            switch error {
            case .notAuthorized:
                self?.viewInput?.changedStatus(LoginAccountStatus.notAuthorized)
            default:
                self?.viewInput?.changedStatus(LoginAccountStatus.error)
            }
        }
    }
}
