//
//  RegisteredAccountTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

struct RegisteredAccountTranslater: Translator {
    typealias Input = (accounts: [ACAccount], selectedIdentifier: String?)
    typealias Output = RegisteredAccountsModel
    
    func translate(_ entity: (accounts: [ACAccount], selectedIdentifier: String?)) throws -> RegisteredAccountsModel {
        var registeredAccountsModel: RegisteredAccountsModel = RegisteredAccountsModel()
        entity.accounts.enumerated().forEach({ (index: Int, account: ACAccount) -> () in
            var registeredAccountModel = RegisteredAccountModel(account: account, index: index)
            registeredAccountModel.isSelected = registeredAccountModel.identifier == entity.selectedIdentifier
            registeredAccountsModel.accounts.append(registeredAccountModel)
        })
        
        return registeredAccountsModel
    }
}
