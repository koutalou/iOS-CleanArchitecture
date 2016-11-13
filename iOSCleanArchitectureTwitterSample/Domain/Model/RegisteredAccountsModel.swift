//
//  LoginUserModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation
import Accounts

struct RegisteredAccountsModel {
    var accounts: [RegisteredAccountModel] = []
}

struct RegisteredAccountModel {
    var name: String = ""
    var identifier: String = ""
    var id: Int = 0
    var isSelected: Bool = false
    
    init(account: ACAccount, index: Int) {
        name = account.username
        identifier = account.identifier as String? ?? ""
        id = index
    }
}
