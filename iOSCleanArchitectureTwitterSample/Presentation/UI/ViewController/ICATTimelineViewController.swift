//
//  ICATTimelineViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol ICATTimelineViewInput: class {
    func setTimelinesModel(_: ICATTimelinesModel) -> Void
    func changedStatus(_: ICATTimelineStatus) -> Void
}

class ICATTimelineViewController: UIViewController, ICATTimelineViewInput, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ICATTimelinePresenter = ICATTimelinePresenter()
    var timelines: Array<ICATTimelineModel>?
    var timelineStatus:ICATTimelineStatus = .Loading
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewInput = self
        presenter.loadTimelines()
    }
    
    // MARK: ICATTimelineViewInput
    
    func setTimelinesModel(timelinesModel: ICATTimelinesModel) {
        timelines = timelinesModel.timelines
        self.tableView.reloadData()
    }
    
    func changedStatus(status: ICATTimelineStatus) {
        timelineStatus = status
        if (status == .NotAuthorized) {
            performSegueWithIdentifier("LoginAccount", sender: nil)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (timelineStatus != .Normal) {
            return 1
        }
        return timelines?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch timelineStatus {
        case .Normal:
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineViewCell", forIndexPath: indexPath) as! ICATTimelineViewCell
            
            let timeline: ICATTimelineModel = timelines![indexPath.row]
            cell.updateCell(timeline)
            
            return cell
        case .NotAuthorized:
            return tableView.dequeueReusableCellWithIdentifier("Nodata", forIndexPath: indexPath)
        case .Loading:
            return tableView.dequeueReusableCellWithIdentifier("Loading", forIndexPath: indexPath)
        case .Error:
            return tableView.dequeueReusableCellWithIdentifier("Error", forIndexPath: indexPath)
        case .None:
            return tableView.dequeueReusableCellWithIdentifier("Nodata", forIndexPath: indexPath)
        }
    }
}
