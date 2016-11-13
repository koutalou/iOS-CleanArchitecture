//
//  AppError.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2015/12/21.
//  Copyright © 2015年 koutalou. All rights reserved.
//

import Foundation

enum AppError: Error {
    case noError
    case network
    case notAuthorized
    case generic
    
    var isError: Bool {
        return self != .noError
    }
}
