//
//  ICATRegisteredAccountTranslater.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

class ICATRegisteredAccountTranslater: NSObject {
    
    class func generateRegisteredAccount(accounts: Array<ACAccount>, selectedIdentifier: String?) -> ICATRegisteredAccountsModel {
        let registeredAccountsModel: ICATRegisteredAccountsModel = ICATRegisteredAccountsModel()
        accounts.enumerate().forEach({ (index: Int, account: ACAccount) -> () in
            let registeredAccountModel = ICATRegisteredAccountModel(account: account, index: index)
            registeredAccountModel.isSelected = registeredAccountModel.identifier == selectedIdentifier
            registeredAccountsModel.accounts.append(registeredAccountModel)
        })
        
        return registeredAccountsModel
    }
}