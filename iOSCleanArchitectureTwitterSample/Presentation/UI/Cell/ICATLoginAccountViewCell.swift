//
//  ICATLoginAccountViewCell.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

class ICATLoginAccountViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func updateCell(accountModel: ICATRegisteredAccountModel) {
        self.name.text = "@" + accountModel.name
        self.isSelected(accountModel.isSelected)
    }
    
    func isSelected(isSelected: Bool) {
        if (isSelected) {
            self.backgroundColor = UIColor(red: 198/255.0, green: 227/255.0, blue: 219/255.0, alpha: 1)
        } else {
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}