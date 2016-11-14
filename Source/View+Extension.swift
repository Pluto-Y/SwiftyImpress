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
private var completionKey: Void?

public typealias CompletionHandler = (_ view: View) -> ()

public struct CompleteClosureWrapper {
    var closure: CompletionHandler
    init(_ closure: @escaping CompletionHandler) {
        self.closure = closure
    }
}

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
    
    public var completion: CompleteClosureWrapper? {
        get {
            if let completion = objc_getAssociatedObject(base, &completionKey) as? CompleteClosureWrapper {
                return completion
            }
            return nil
        }
        set {
            objc_setAssociatedObject(base, &completionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @discardableResult public func with(transform: CATransform3D) -> SwiftyImpress {
        self.transform3D = transform
        return self
    }
    
    @discardableResult public func when(entered completion: CompletionHandler?) -> SwiftyImpress {
        
        if let closure = completion {
            self.completion = CompleteClosureWrapper(closure)
        } else {
            self.completion = nil
        }
        
        return self
    }
}
