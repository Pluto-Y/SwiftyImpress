//
//  Transform.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 11/10/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

public struct Axis: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var x = Axis(rawValue: 1 << 0)
    
    public static var y = Axis(rawValue: 1 << 1)
    
    public static var z = Axis(rawValue: 1 << 2)
    
    public static var all: Axis = [.x, .y, .z]
}

public enum TransformElement {
    case translation(Axis, CGFloat)
    case scale(Axis, CGFloat)
    case rotation(Axis, CGFloat)
    case transform(CATransform3D)
}


public typealias Transform = (CATransform3D) -> CATransform3D

precedencegroup ConnectionGroup {
    associativity: left
}

infix operator -->: ConnectionGroup

public func -->(left: @escaping Transform, right: @escaping Transform) -> Transform {
    return { transform in
        right(left(transform))
    }
}

public func translation(_ value: CGFloat, _ coordinate: Axis = .x) -> Transform {
    return { transform in
        guard !coordinate.contains(.all) else { return CATransform3DTranslate(transform, value, value, value) }
        
        var transform = transform
        if coordinate.contains(.x) {
            transform = CATransform3DTranslate(transform, value, 0, 0)
        }
        if coordinate.contains(.y) {
            transform = CATransform3DTranslate(transform, 0, value, 0)
        }
        if coordinate.contains(.z) {
            transform = CATransform3DTranslate(transform, 0, 0, value)
        }
        return transform
    }
}

public func rotation(_ angle: CGFloat, _ coordinate: Axis = .z) -> Transform {
    return { transform in
        guard !coordinate.contains(.all) else { return CATransform3DRotate(transform, angle, 1, 1, 1) }
        
        var transform = transform
        let value = angle / 180 * CGFloat(M_PI)
        if coordinate.contains(.x) {
            transform = CATransform3DRotate(transform, value, 1, 0, 0)
        }
        if coordinate.contains(.y) {
            transform = CATransform3DRotate(transform, value, 0, 1, 0)
        }
        if coordinate.contains(.z) {
            transform = CATransform3DRotate(transform, value, 0, 0, 1)
        }
        return transform
    }
}

public func scale(_ scale: CGFloat, _ coordinate: Axis = .all) -> Transform {
    return { transform in
        guard !coordinate.contains(.all) else { return CATransform3DScale(transform, scale, scale, scale) }
        
        var transform = transform
        if coordinate.contains(.x) {
            transform = CATransform3DScale(transform, scale, 0, 0)
        }
        if coordinate.contains(.y) {
            transform = CATransform3DScale(transform, 0, scale, 0)
        }
        if coordinate.contains(.z) {
            transform = CATransform3DScale(transform, 0, 0, scale)
        }
        return transform
    }
}

public func transform(_ transform: CATransform3D) -> Transform {
    return { _ in
        return transform
    }
}

public func pure(_ t: CATransform3D) -> Transform {
    return { _ in
        return t
    }
}

public func makeTransforms(_ transforms: [Transform], from transform: CATransform3D = CATransform3DIdentity) -> CATransform3D {
    return transforms.reduce(pure(CATransform3DIdentity)) { result, next in
        result --> next
    }(transform)
}


