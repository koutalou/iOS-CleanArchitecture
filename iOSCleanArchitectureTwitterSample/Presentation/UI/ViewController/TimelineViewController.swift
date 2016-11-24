//
//  TimelineViewController.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/20.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import UIKit

protocol TimelineViewInput: class {
    func setCondition(isSelectable: Bool)
    func setTimelinesModel(_: TimelinesModel)
    func setUserModel(_: UserViewModel)
    func changedStatus(_: TimelineStatus)
}

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: TimelinePresenter?
    var timelines: [TimelineViewModel] = []
    var timelineStatus:TimelineStatus = .loading
    
    fileprivate let headerUserViewNib = Nib<TimelineUserHeaderView>()
    fileprivate var headerUserView: TimelineUserHeaderView!
    
    public func inject(presenter: TimelinePresenter) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.loadCondition()
        presenter?.loadTimelines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: Private and Set Condition
extension TimelineViewController {
    func setupUI() {
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerUserView = headerUserViewNib.view()
    }
}

// MARK: TimelineViewInput
extension TimelineViewController: TimelineViewInput {
    func setCondition(isSelectable: Bool) {
        tableView.allowsSelection = isSelectable
        
        if !isSelectable {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setUserModel(_ userModel: UserViewModel) {
        headerUserView.updateView(userModel)
        tableView.tableHeaderView = headerUserView
    }
    
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
extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (timelineStatus != .normal) {
            return 1
        }
        return timelines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch timelineStatus {
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! TimelineViewCell
            
            let timeline: TimelineViewModel = timelines[indexPath.row]
            cell.updateCell(timeline)
            
            return cell
        case .notAuthorized:
            return tableView.dequeueReusableCell(withIdentifier: "NotAuthorized", for: indexPath)
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
        case .error:
            return tableView.dequeueReusableCell(withIdentifier: "Error", for: indexPath)
        case .none:
            return tableView.dequeueReusableCell(withIdentifier: "Nodata", for: indexPath)
        }
    }
}

// MARK: UITableView Delegate
extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch timelineStatus {
        case .normal:
            let timeline: TimelineViewModel = timelines[indexPath.row]
            presenter?.selectCell(timeline: timeline)
        default:
            return
        }
    }
}
