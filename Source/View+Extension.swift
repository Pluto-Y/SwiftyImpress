//
//  View+Extension.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 24/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

public extension CATransform3D {
    
    public init(x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0, scaleX: CGFloat = 0.0, scaleY: CGFloat = 0.0, scaleZ: CGFloat = 0.0, rotateX: CGFloat = 0.0, rotateY: CGFloat = 0.0, rotateZ: CGFloat = 0.0) {
        self.init()
        self = CATransform3DScale(self, scaleX, scaleY, scaleZ)
        self = CATransform3DTranslate(self, x, y, z)
        self = CATransform3DRotate(self, rotateX, 1, 0, 0)
        self = CATransform3DRotate(self, rotateY, 0, 1, 0)
        self = CATransform3DRotate(self, rotateZ, 0, 0, 1)
    }
}

public extension View: SwiftyImpressCompatible { }

// MARK: - Associated Key
private var transform3DKey: Void?;

public extension SwiftyImpress where Base: View {
    public var transform3D: CATransform3D? {
        get {
            return objc_getAssociatedObject(self, &transform3DKey) as? CATransform3D
        }
        set {
            objc_setAssociatedObject(self, &transform3DKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}
