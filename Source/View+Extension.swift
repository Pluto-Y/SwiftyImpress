//
//  View+Extension.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 24/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//


extension View: SwiftyImpressCompatible { }

// MARK: - Associated Key
private var transform3DKey: Void?;

public extension SwiftyImpress where Base: View {
    public var transform3D: CATransform3D {
        get {
            if let transform = objc_getAssociatedObject(base, &transform3DKey) as? CATransform3D  {
                return transform
            }
            return CATransform3DIdentity
        }
        set {
            objc_setAssociatedObject(base, &transform3DKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
