//
//  ViewController.swift
//  iOS Example
//
//  Created by Pluto Y on 23/09/2016.
//  Copyright © 2016 com.pluto-y. All rights reserved.
//

import UIKit
import SwiftyImpress

class ViewController: UIViewController {

    @IBOutlet weak var testView: ImpressView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let step1 = UIView(frame: testView.bounds)
        step1.backgroundColor = UIColor.yellow
        step1.transform3D = CATransform3D(x: 100)
        testView.addStep(view: step1)
        
        let step2 = UIView(frame: testView.bounds)
        step2.backgroundColor = UIColor.orange
        testView.addStep(view: step2)
        
        let step3 = UIView(frame: testView.bounds)
        step3.backgroundColor = UIColor.green
        testView.addStep(view: step3)
    }

}

