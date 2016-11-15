//
//  TimelineViewModel.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2016/11/15.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import Foundation

protocol TimelineViewModel {
    var name: String { get }
    var screenName: String { get }
    var profileUrl: String { get }
    var tweet: String { get }
}

protocol UserViewModel {
    var name: String { get }
    var screenName: String { get }
    var profileUrl: String { get }
    var profileBackgroundUrl: String { get }
    var userDescription: String { get }
}
