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
    func closeView()
}

class ICATLoginAccountViewController: UIViewController, ICATLoginAccountViewInput, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: ICATLoginAccountPresenter = ICATLoginAccountPresenter()
    var twitterAccountsModel: ICATRegisteredAccountsModel?
    var accountStatus: ICATLoginAccountStatus = .none

    override func viewDidLoad() {
        presenter.viewInput = self
        presenter.loadAccounts()
    }
    
    // MARK: ICATLoginUserView
    
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
    
    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Table view data source
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
        presenter.selectAccount(indexPath.row)
    }
    
    // MARK: UIButton
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapReload(_ sender: UIBarButtonItem) {
        // Reload accounts
        presenter.loadAccounts()
    }
    
}
