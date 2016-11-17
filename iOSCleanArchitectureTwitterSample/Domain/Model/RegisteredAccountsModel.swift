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
    let name: String
    let identifier: String
    let id: Int
    
    var isSelected: Bool = false
    
    init(account: ACAccount, index: Int) {
        name = account.username
        identifier = account.identifier as String? ?? ""
        id = index
    }
}
