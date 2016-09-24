//
//  ImpressView+Extensions.swift
//  SwiftyImpress
//
//  Created by Pluto Y on 23/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

public extension SwiftyImpress where Base: ImpressView {
        
}

extension ImpressView: SwiftyImpressCompatible { }

//extension CALayer: SwiftyImpressCompatible{}

//extension SwiftyImpress where Base: CALayer {
//    func resizeSubLayers(scaleX: CGFloat, scaleY: CGFloat) {
//        print("scale x:\(base.value(forKeyPath: "transform.scale.x"))")
//        print("scale y:\(base.value(forKeyPath: "transform.scale.y"))")
//        base.transform = CATransform3DScale(base.transform, scaleX, scaleY, 0)
////        base.transform = CATransform3DMakeScale(scaleX, scaleY, 0)
//        if let subLayers = base.sublayers {
//            for layer in subLayers {
//                layer.si.resizeSubLayers(scaleX: scaleX, scaleY: scaleY)
//            }
//        }
//    }
//}

public class ImpressView: View, CAAnimationDelegate {
    
    public var duration: CFTimeInterval = 2.0
    
    private let tapRecognizer = UITapGestureRecognizer()
    private let swipeLeftRecognizer = UISwipeGestureRecognizer()
    private let swipeRightRecognizer = UISwipeGestureRecognizer()
    private var desTransform: CATransform3D?
    private var originSize = CGSize.zero
    private var stepViews = [View]()
    private var currStep: Int = 0
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
        self.bgLayer.backgroundColor = UIColor.red.cgColor
        self.layer.addSublayer(bgLayer)
#endif
        tapRecognizer.addTarget(self, action: #selector(self.tapHandler(gestureRecognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        swipeLeftRecognizer.addTarget(self, action: #selector(self.swipeHandler(gestureRecognizer:)))
        swipeRightRecognizer.addTarget(self, action: #selector(self.swipeHandler(gestureRecognizer:)))
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
        next()
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
        currStep += 1
        let originTransform = (bgLayer.presentation() ?? bgLayer).transform
        desTransform = CATransform3DTranslate(originTransform, -bgLayer.frame.width, 0, 0)
        animate(originTransform: originTransform)
    }
    
    public func prev() {
        currStep -= 1
        let originTransform = (bgLayer.presentation() ?? bgLayer).transform
        desTransform = CATransform3DTranslate(originTransform, bgLayer.frame.width, 0, 0)
        animate(originTransform: originTransform)
    }
    
    private func animate(originTransform: CATransform3D) {
        
        let animation = CABasicAnimation()
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.keyPath = "transform"
        animation.duration = duration
        animation.fromValue = NSValue(caTransform3D: originTransform)//bgLayer.transform
        animation.toValue = NSValue(caTransform3D: desTransform!)
        bgLayer.add(animation, forKey: nil)
    }
    
    public func addStep(view: View) {
        stepViews.append(view)
        view.layer.position.x = bgLayer.position.x + CGFloat(stepViews.count - 1) * bgLayer.frame.width
        view.layer.position.y = bgLayer.position.y
        view.layer.transform = CATransform3DMakeScale(scaleX, scaleY, 0)
        bgLayer.addSublayer(view.layer)
    }
    
    public func removeStep(view: View) {
        if stepViews.contains(view) {
            stepViews.remove(at: stepViews.index(of: view)!)
            view.layer.removeFromSuperlayer()
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transform = desTransform {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            bgLayer.transform = transform
            CATransaction.commit()
        }
    }
    
}
