//
//  ICATLoginAccountViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol ICATLoginAccountViewInput: class {
    func setAccountsModel(_: ICATRegisteredAccountsModel) -> Void
    func changedStatus(_: ICATLoginAccountStatus) -> Void
    func selectAccountResult(_: Bool) -> Void
}

class ICATLoginAccountViewController: UIViewController, ICATLoginAccountViewInput, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var presenter: ICATLoginAccountPresenter = ICATLoginAccountPresenter()
    var twitterAccountsModel: ICATRegisteredAccountsModel?
    var accountStatus: ICATLoginAccountStatus = .None

    override func viewDidLoad() {
        presenter.viewInput = self
        presenter.loadAccounts()
    }
    
    // MARK: ICATLoginUserView
    
    func setAccountsModel(accountsModel: ICATRegisteredAccountsModel) {
        twitterAccountsModel = accountsModel
        self.tableView.reloadData()
    }
    
    func changedStatus(status: ICATLoginAccountStatus) {
        switch status {
        case .Normal:
            footerLabel.text = "Select use account"
        case .Error:
            footerLabel.text = "An error occured"
        case .NotAuthorized:
            footerLabel.text = "Not authorized"
        case .None:
            footerLabel.text = "No twitter user"
        }
    }
    
    func selectAccountResult(isSuccess: Bool) {
        if (isSuccess) {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        // Notify Error as necessary
    }
    
    // MARK: Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (twitterAccountsModel?.accounts.count) ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LoginAccountCell", forIndexPath: indexPath) as! ICATLoginAccountViewCell
        
        let account: ICATRegisteredAccountModel = twitterAccountsModel!.accounts[indexPath.row]
        cell.updateCell(account)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presenter.selectAccount(indexPath.row)
    }
    
    // MARK: UIButton
    @IBAction func tapCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapReload(sender: UIBarButtonItem) {
        // Reload accounts
        presenter.loadAccounts()
    }
    
}
