//
//  ICATRegisteredAccountTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

struct ICATRegisteredAccountTranslater: Translator {
    typealias Input = (accounts: [ACAccount], selectedIdentifier: String?)
    typealias Output = ICATRegisteredAccountsModel
    
    func translate(_ entity: (accounts: [ACAccount], selectedIdentifier: String?)) throws -> ICATRegisteredAccountsModel {
        var registeredAccountsModel: ICATRegisteredAccountsModel = ICATRegisteredAccountsModel()
        entity.accounts.enumerated().forEach({ (index: Int, account: ACAccount) -> () in
            var registeredAccountModel = ICATRegisteredAccountModel(account: account, index: index)
            registeredAccountModel.isSelected = registeredAccountModel.identifier == entity.selectedIdentifier
            registeredAccountsModel.accounts.append(registeredAccountModel)
        })
        
        return registeredAccountsModel
    }
}
