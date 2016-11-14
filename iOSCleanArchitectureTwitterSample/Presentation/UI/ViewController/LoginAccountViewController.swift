//
//  LoginAccountViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol LoginAccountViewInput: class {
    func setAccountsModel(_: RegisteredAccountsModel)
    func changedStatus(_: LoginAccountStatus)
}

class LoginAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: LoginAccountPresenter?
    var twitterAccountsModel: RegisteredAccountsModel?
    var accountStatus: LoginAccountStatus = .none

    public func inject(presenter: LoginAccountPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.loadAccounts()
    }
}

// MARK: LoginUserView
extension LoginAccountViewController: LoginAccountViewInput {
    func setAccountsModel(_ accountsModel: RegisteredAccountsModel) {
        twitterAccountsModel = accountsModel
        self.tableView.reloadData()
    }
    
    func changedStatus(_ status: LoginAccountStatus) {
        switch status {
        case .normal:
            footerLabel.text = "Select use account"
        case .error:
            footerLabel.text = "An error occured"
        case .notAuthorized:
            footerLabel.text = "Not authorized"
        case .none:
            footerLabel.text = "No twitter user"
        }
    }
}

// MARK: UIButton
extension LoginAccountViewController {
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        presenter?.tapCancel()
    }
    
    @IBAction func tapReload(_ sender: UIBarButtonItem) {
        // Reload accounts
        presenter?.tapReload()
    }
}

// MARK: Table view data source
extension LoginAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (twitterAccountsModel?.accounts.count) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginAccountCell", for: indexPath) as! LoginAccountViewCell
        
        let account: RegisteredAccountModel = twitterAccountsModel!.accounts[indexPath.row]
        cell.updateCell(account)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectAccount(indexPath.row)
    }
}
