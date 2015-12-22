//
//  ICATLoginUserModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

class ICATRegisteredAccountsModel: NSObject {
    var accounts: [ICATRegisteredAccountModel] = []
}

class ICATRegisteredAccountModel: NSObject {
    var name: String = ""
    var identifier: String = ""
    var id: Int = 0
    var isSelected: Bool = false
    
    required init(account: ACAccount, index: Int) {
        super.init()
        name = account.username
        identifier = account.identifier ?? ""
        id = index
    }
}