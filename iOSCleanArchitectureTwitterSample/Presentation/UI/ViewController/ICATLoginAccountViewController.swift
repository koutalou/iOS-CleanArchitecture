//
//  ICATLoginAccountViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol ICATLoginAccountViewInput: class {
    func setAccountsModel(_: ICATRegisteredAccountsModel)
    func changedStatus(_: ICATLoginAccountStatus)
}

class ICATLoginAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var wireframe: LoginAccountWireframe?
    var presenter: ICATLoginAccountPresenter?
    var twitterAccountsModel: ICATRegisteredAccountsModel?
    var accountStatus: ICATLoginAccountStatus = .none

    public func inject(presenter: ICATLoginAccountPresenter, wireframe: LoginAccountWireframe) {
        self.presenter = presenter
        self.wireframe = wireframe
    }
    
    override func viewDidLoad() {
        presenter?.loadAccounts()
    }
}

// MARK: ICATLoginUserView
extension ICATLoginAccountViewController: ICATLoginAccountViewInput {
    func setAccountsModel(_ accountsModel: ICATRegisteredAccountsModel) {
        twitterAccountsModel = accountsModel
        self.tableView.reloadData()
    }
    
    func changedStatus(_ status: ICATLoginAccountStatus) {
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
extension ICATLoginAccountViewController {
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        presenter?.tapCancel()
    }
    
    @IBAction func tapReload(_ sender: UIBarButtonItem) {
        // Reload accounts
        presenter?.tapReload()
    }
}

// MARK: Table view data source
extension ICATLoginAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (twitterAccountsModel?.accounts.count) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginAccountCell", for: indexPath) as! ICATLoginAccountViewCell
        
        let account: ICATRegisteredAccountModel = twitterAccountsModel!.accounts[indexPath.row]
        cell.updateCell(account)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectAccount(indexPath.row)
    }
}
