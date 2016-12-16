//
//  ImpressView+Extensions.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 23/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

public extension SwiftyImpress where Base: ImpressView {
        
}

@objc public protocol ImpressViewDelegate {
    @objc optional func impressView(_: ImpressView, endInView view: View)
}

public final class ImpressView: View, CAAnimationDelegate {
    
    private let delta: CGFloat = 10e-6
    
    public var duration: CFTimeInterval = 1.0
    public var delegate: ImpressViewDelegate?
    
    private let tapRecognizer = UITapGestureRecognizer()
    private let swipeLeftRecognizer = UISwipeGestureRecognizer()
    private let swipeRightRecognizer = UISwipeGestureRecognizer()
    private var desTransform: CATransform3D?
    private var originSize = CGSize.zero
    private var stepViews = [View]()
    private var prevStep: Int = 0
    private var currStep: Int = 0 {
        willSet {
            prevStep = currStep
        }
        didSet {
            guard let allSublayers = bgLayer.sublayers else {
                return
            }
            var step = 0
            for layer in allSublayers {
                if step == currStep {
                    layer.opacity = 1.0
                } else {
                    layer.opacity = 0.3
                }
                step += 1
            }
        }
    }
    
    private var bgLayer = CALayer()
    private var scaleX: CGFloat = 1.0
    private var scaleY: CGFloat = 1.0
    
    public var allowTap = true {
        didSet {
            if allowTap && !oldValue {
                addGestureRecognizer(tapRecognizer)
            }
            
            if !allowTap && oldValue {
                removeGestureRecognizer(tapRecognizer)
            }
        }
    }
    
    public var allowSwipe = true {
        didSet {
            if allowSwipe && !oldValue {
                addGestureRecognizer(swipeLeftRecognizer)
                addGestureRecognizer(swipeRightRecognizer)
            }
            
            if !allowSwipe && oldValue {
                addGestureRecognizer(swipeLeftRecognizer)
                addGestureRecognizer(swipeRightRecognizer)
            }
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initAll()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initAll()
    }
    
    private func initAll() {
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(swipeLeftRecognizer)
        addGestureRecognizer(swipeRightRecognizer)
#if os(iOS) || os(tvOS)
        //self.bgLayer.backgroundColor = UIColor.red.cgColor
        self.layer.addSublayer(bgLayer)
#endif
        tapRecognizer.addTarget(self, action: #selector(self.tapHandler(gestureRecognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        swipeLeftRecognizer.addTarget(self, action: #selector(self.swipeHandler(gestureRecognizer:)))
        swipeRightRecognizer.addTarget(self, action: #selector(self.swipeHandler(gestureRecognizer:)))
        bgLayer.addObserver(self, forKeyPath: "presentationLayer", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "presentationLayer" {
            print(bgLayer.value(forKey: "presentationLayer") ?? "")
        }
    }
    
    public override func layoutSubviews() {
        if self.originSize == CGSize.zero {
            self.originSize = self.frame.size
        }
        
        if bgLayer.frame == CGRect.zero {
            bgLayer.frame = self.bounds
        }
    }
    #if os(iOS) || os(tvOS)
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if originSize != self.frame.size {
            scaleX *= self.frame.size.width / originSize.width
            scaleY *= self.frame.size.height / originSize.height
            bgLayer.transform = CATransform3DScale(bgLayer.transform, scaleX, scaleY, 0)
            desTransform = bgLayer.transform
            originSize = self.frame.size
        }
    }
    #endif
    
    @objc func tapHandler(gestureRecognizer: UITapGestureRecognizer) {
        let bgPresentLayer = bgLayer.presentation() ?? bgLayer
        guard let allSublayers = bgPresentLayer.sublayers else {
            return
        }
        
        let point = gestureRecognizer.location(in: self)
        guard layer.contains(point) else {
            return
        }
        
        var step = 0
        let pointInBgPresentLayer = layer.convert(point, to: bgPresentLayer)
        for sublayer in allSublayers {
            let frame = (sublayer.presentation() ?? sublayer).frame
            if frame.contains(pointInBgPresentLayer) {
                if step != currStep {
                    currStep = step
                    animate()
                    
                }
                break;
            }
            step += 1
        }
    }
    
    @objc func swipeHandler(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case UISwipeGestureRecognizerDirection.left:
            next()
        case UISwipeGestureRecognizerDirection.right:
            prev()
        default:
            print("")
        }
    }
    
    public func next() {
        currStep = (currStep + 1) % stepViews.count
        animate()
    }
    
    public func prev() {
        if currStep == 0 {
            currStep = stepViews.count - 1
        } else {
            currStep = currStep - 1
        }
        animate()
    }
    
    private func animate() {
        let originTransform = (bgLayer.presentation() ?? bgLayer).transform
        desTransform = CATransform3DInvert(stepViews[currStep].si.transform3D)
        let animation = CABasicAnimation()
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.keyPath = "transform"
        animation.duration = duration
        animation.fromValue = NSValue(caTransform3D: originTransform)//bgLayer.transform
        animation.toValue = NSValue(caTransform3D: desTransform!)
        bgLayer.removeAnimation(forKey: "sianimation\(prevStep)")
        bgLayer.add(animation, forKey: "sianimation\(currStep)")
    }
    
    @discardableResult public func addSteps(_ views: View...) -> Self {
        for view in views {
            addStep(view: view)
        }
        return self;
    }
    
    @discardableResult public func addStep(view: View) -> Self {
        stepViews.append(view)
        
        // Re-position the center of the layer and make a scale for it
        view.layer.position.x = bgLayer.position.x
        view.layer.position.y = bgLayer.position.y
        view.layer.transform = CATransform3DMakeScale(scaleX, scaleY, 0)
        
        // Add it to right position
        view.layer.transform = view.si.transform3D
        bgLayer.addSublayer(view.layer)
        
        if stepViews.count == 1 {
            currStep = 0
            bgLayer.transform = CATransform3DInvert(view.si.transform3D)
            view.layer.opacity = 1.0
        } else {
            view.layer.opacity = 0.3
        }
        return self
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transform = desTransform, flag {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            bgLayer.transform = transform
            bgLayer.removeAllAnimations()
            CATransaction.commit()
            let activeView = stepViews[currStep]
            if let handler = activeView.si.completion {
                handler.closure(activeView)
            }
            delegate?.impressView?(self, endInView: activeView)
        }
    }
}
