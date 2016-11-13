//
//  TimelineViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol TimelineViewInput: class {
    func setTimelinesModel(_: TimelinesModel) -> Void
    func changedStatus(_: TimelineStatus) -> Void
}

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private weak var wireframe: TimelineWireframe?
    var presenter: TimelinePresenter?
    var timelines: Array<TimelineModel>?
    var timelineStatus:TimelineStatus = .loading
    
    public func inject(presenter: TimelinePresenter, wireframe: TimelineWireframe) {
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

// MARK: TimelineViewInput
extension TimelineViewController: TimelineViewInput {
    func setTimelinesModel(_ timelinesModel: TimelinesModel) {
        timelines = timelinesModel.timelines
        self.tableView.reloadData()
    }
    
    func changedStatus(_ status: TimelineStatus) {
        timelineStatus = status
        self.tableView.reloadData()
    }
}

// MARK: Button Event
extension TimelineViewController {
    @IBAction func tapPersonButton(_ sender: Any) {
        presenter?.tapPersonButton()
    }
}

// MARK: Table view data source
extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! TimelineViewCell
            
            let timeline: TimelineModel = timelines![indexPath.row]
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
