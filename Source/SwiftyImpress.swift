//
//  SwiftyImpress.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 23/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias View = UIView
#else
    import AppKit
    public typealias View = NSView
#endif

public class SwiftyImpress<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol SwiftyImpressCompatible {
    associatedtype CompatibleType
    var si: CompatibleType { get }
}

public extension SwiftyImpressCompatible {
    public var si: SwiftyImpress<Self> {
        get { return SwiftyImpress(self) }
        set { }
    }
}
