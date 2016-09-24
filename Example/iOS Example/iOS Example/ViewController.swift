//
//  ViewController.swift
//  iOS Example
//
//  Created by Pluto Y on 23/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

import UIKit
import SwiftyImpress

class ViewController: UIViewController, ImpressViewDelegate {

    @IBOutlet weak var testView: ImpressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var frame = testView.bounds
        frame.size.width /= 2.0
        
        let step1 = UIView(frame: frame)
        step1.backgroundColor = UIColor.yellow
        step1.tag = 1
        testView.addStep(view: step1)
        
        var step2 = UIView(frame: frame)
        step2.si.transform3D = CATransform3D(x: (frame.size.height + frame.size.width)/2.0, z: 100, rotateZ: 90)
        step2.backgroundColor = UIColor.orange
        step2.tag = 2
        testView.addStep(view: step2)
        
        var step3 = UIView(frame: frame)
        step3.si.transform3D = CATransform3D(x: frame.size.width + frame.size.height, scaleX: 2, scaleY: 2, scaleZ: 2)
        step3.backgroundColor = UIColor.green
        step3.tag = 3
        testView.addStep(view: step3)
    }
    
    func impressView(_: ImpressView, endInView view: View) {
        print("finished step : \(view.tag)")
    }

}

