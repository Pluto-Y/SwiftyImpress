//
//  CATransform3D+Extension.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 25/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

public extension CATransform3D {
    public init(transform: CATransform3D = CATransform3DIdentity,x: CGFloat = 0.0, y: CGFloat = 0.0, z: CGFloat = 0.0, scaleX: CGFloat = 0.0, scaleY: CGFloat = 0.0, scaleZ: CGFloat = 0.0, rotateX: CGFloat = 0.0, rotateY: CGFloat = 0.0, rotateZ: CGFloat = 0.0) {
        var t = transform
        if scaleX != 0 || scaleY != 0 || scaleZ != 0 {
            t = CATransform3DScale(t, scaleX, scaleY, scaleZ)
        }
        if x != 0 || y != 0 || z != 0 {
            t = CATransform3DTranslate(t, x, y, z)
        }
        if rotateX != 0 {
            t = CATransform3DRotate(t, rotateX / 180 * CGFloat(M_PI), 1, 0, 0)
        }
        if rotateY != 0 {
            t = CATransform3DRotate(t, rotateY / 180 * CGFloat(M_PI), 0, 1, 0)
        }
        if rotateZ != 0 {
            t = CATransform3DRotate(t, rotateZ / 180 * CGFloat(M_PI), 0, 0, 1)
        }
        self = t
    }
    
}


