//
//  ICATError.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

enum ICATError {
    case NoError
    case Network
    case NotAuthorized
    case Generic
    
    var isError: Bool {
        return self != .NoError
    }
}