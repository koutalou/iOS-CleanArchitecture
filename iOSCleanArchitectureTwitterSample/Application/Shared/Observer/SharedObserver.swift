//
//  SharedObserver.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/15.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import RxSwift

class SharedObserver {
    static let instance: SharedObserver = SharedObserver()
    
    fileprivate let selectPerson: PublishSubject<Void> = PublishSubject()
}

// MARK: - Interface
public protocol SelectPersonObserver {
    var selectPersonObserver: PublishSubject<Void> { get }
}

// MARK: - Implementation
extension SharedObserver: SelectPersonObserver {
    var selectPersonObserver: PublishSubject<Void> {
        return selectPerson
    }
}
