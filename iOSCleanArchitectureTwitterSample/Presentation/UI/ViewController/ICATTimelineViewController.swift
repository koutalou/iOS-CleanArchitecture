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

class ICATTimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private weak var wireframe: TimelineWireframe?
    var presenter: ICATTimelinePresenter?
    var timelines: Array<ICATTimelineModel>?
    var timelineStatus:ICATTimelineStatus = .loading
    
    public func inject(presenter: ICATTimelinePresenter, wireframe: TimelineWireframe) {
        self.presenter = presenter
        self.wireframe = wireframe
    }

    override func viewDidLoad() {
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.loadTimelines()
    }
}

// MARK: ICATTimelineViewInput
extension ICATTimelineViewController: ICATTimelineViewInput {
    func setTimelinesModel(_ timelinesModel: ICATTimelinesModel) {
        timelines = timelinesModel.timelines
        self.tableView.reloadData()
    }
    
    func changedStatus(_ status: ICATTimelineStatus) {
        timelineStatus = status
        if (status == .notAuthorized) {
            performSegue(withIdentifier: "LoginAccount", sender: nil)
        }
        
        self.tableView.reloadData()
    }
}

// MARK: Button Event
extension ICATTimelineViewController {
    @IBAction func tapPersonButton(_ sender: Any) {
        presenter?.tapPersonButton()
    }
}

// MARK: Table view data source
extension ICATTimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (timelineStatus != .normal) {
            return 1
        }
        return timelines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch timelineStatus {
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! ICATTimelineViewCell
            
            let timeline: ICATTimelineModel = timelines![indexPath.row]
            cell.updateCell(timeline)
            
            return cell
        case .notAuthorized:
            return tableView.dequeueReusableCell(withIdentifier: "Nodata", for: indexPath)
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
        case .error:
            return tableView.dequeueReusableCell(withIdentifier: "Error", for: indexPath)
        case .none:
            return tableView.dequeueReusableCell(withIdentifier: "Nodata", for: indexPath)
        }
    }
}
