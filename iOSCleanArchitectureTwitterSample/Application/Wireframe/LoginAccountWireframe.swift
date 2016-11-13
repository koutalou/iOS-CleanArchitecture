//
//  LoginAccountWireframe.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import Foundation

protocol LoginAccountWireframe: class {
    weak var viewController: ICATLoginAccountViewController? { get set }
    
    func closeView()
}

class LoginAccountWireframeImpl: LoginAccountWireframe {
    weak var viewController: ICATLoginAccountViewController?
    
    func closeView() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
