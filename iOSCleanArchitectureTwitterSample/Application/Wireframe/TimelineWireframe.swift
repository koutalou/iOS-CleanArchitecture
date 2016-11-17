//
//  TimelineWireframe.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

protocol TimelineWireframe: class {
    weak var viewController: TimelineViewController? { get set }
    
    func showLogin()
    func showUserTimeline(screenName: String)
}

class HomeTimelineWireframeImpl: TimelineWireframe {
    weak var viewController: TimelineViewController?
    
    func showLogin() {
        let nextViewController = LoginAccountBuilder().build()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func showUserTimeline(screenName: String) {
        let nextViewController = UserTimelineBuilder(screenName: screenName).build()
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

class UserTimelineWireframeImpl: TimelineWireframe {
    weak var viewController: TimelineViewController?
    
    func showLogin() {
        // Nothing to do
    }
    
    func showUserTimeline(screenName: String) {
        // Nothing to do
    }
}
