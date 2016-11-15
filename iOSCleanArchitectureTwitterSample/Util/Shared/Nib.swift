//
//  Nib.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2016/11/15.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit

public protocol NibType {
    associatedtype View
    var nib: UINib { get }
    var bundle: Bundle { get }
    var name: String { get }
}

public struct Nib<V: UIView>: NibType {
    public typealias View = V
    public let nib: UINib
    public let bundle: Bundle
    public let name: String
    
    public init() {
        let type = View.classForCoder()
        bundle = Bundle(for: type)
        name = String(describing: type).components(separatedBy: ".").last!
        nib = UINib(nibName: name, bundle: bundle)
    }
    
    public func view() -> V {
        return nib.instantiate(withOwner: nil, options: nil).first as! V
    }
}
