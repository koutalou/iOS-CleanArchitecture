//
//  TimelineWireframe.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import Foundation

protocol TimelineWireframe: class {
    weak var viewController: TimelineViewController? { get set }
    
    func showLogin()
}

class TimelineWireframeImpl: TimelineWireframe {
    weak var viewController: TimelineViewController?
    
    func showLogin() {
        let nextViewController = LoginAccountBuilder().build()
        viewController?.present(nextViewController, animated: true, completion: nil)
    }
}
