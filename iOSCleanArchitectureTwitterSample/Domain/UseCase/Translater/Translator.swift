//
//  Translator.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by koutalou on 2016/11/13.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import Foundation
import RxSwift

public protocol Translator {
    associatedtype Input
    associatedtype Output
    func translate(_: Input) throws -> Output
}

public extension ObservableType {
    public func map<T: Translator>(translator: T) -> Observable<T.Output> where Self.E == T.Input {
        return map { try translator.translate($0) }
    }
}

extension Collection {
    public func map<T: Translator>(translator: T) throws -> [T.Output] where Self.Iterator.Element == T.Input {
        return try map { try translator.translate($0) }
    }
}
