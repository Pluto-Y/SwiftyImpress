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
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.8 * (7.0 / 9.0)))
        view1.si.config { (view) in
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            let lbl = UILabel(frame: CGRect(x: 10, y: 20, width: view1.bounds.width - 20, height: 60))
            lbl.text = "Aren’t you just bored with all those slides-based presentations?"
            lbl.numberOfLines = 0
            view.addSubview(lbl)
            }
            .with(transform: makeTransforms([
                translation(-0.5 * testView.bounds.width, .x),
                translation(-0.5 * testView.bounds.height, .y)
                ]))
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.8 * (7.0 / 9.0)))
        view2.si.config { (view) in
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            let lbl = UILabel(frame: CGRect(x: 10, y: 20, width: view1.bounds.width - 20, height: 100))
            lbl.text = "Don’t you think that presentations given in modern browsers shouldn’t copy the limits of ‘classic’ slide decks?"
            lbl.numberOfLines = 0
            view.addSubview(lbl)
            }
            .from(view1, transform: makeTransforms([
                translation(screenWidth, .x),
                ]))
        
        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.8 * (7.0 / 9.0)))
        view3.si.config { (view) in
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            let lbl = UILabel(frame: CGRect(x: 10, y: 20, width: view1.bounds.width - 20, height: 80))
            lbl.text = "Would you like to impress your audience with stunning visualization of your talk?"
            lbl.numberOfLines = 0
            view.addSubview(lbl)
            }
            .from(view2, transform: makeTransforms([
                translation(screenWidth, .x),
                ]))
        
        let view4 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth * 0.8 * (7.0 / 9.0)))
        view4.si.config { (view) in
            view.si.size = CGSize(width: testView.frame.size.width * 0.8, height: testView.frame.size.width * 0.5)
            let topLbl = UILabel()
            topLbl.text = "then you should try"
            topLbl.font = UIFont.systemFont(ofSize: 24)
            topLbl.frame = CGRect(x: (view.si.size.width - topLbl.intrinsicContentSize.width) / 2.0, y: 25, width: topLbl.intrinsicContentSize.width, height: topLbl.intrinsicContentSize.height)
            view.addSubview(topLbl)
            let centerLbl = UILabel()
            centerLbl.center = CGPoint(x: view.center.x, y: view.center.x)
            centerLbl.text = "Swifty Impress *"
            centerLbl.font = UIFont.systemFont(ofSize: 35)
            centerLbl.frame = CGRect(x: (view.si.size.width - centerLbl.intrinsicContentSize.width) / 2.0, y: (view.si.size.height - centerLbl.intrinsicContentSize.height) / 2.0, width: centerLbl.intrinsicContentSize.width, height: centerLbl.intrinsicContentSize.height)
            view.addSubview(centerLbl)
            let bottomLbl = UILabel()
            bottomLbl.text = "* no rhyme intended"
            bottomLbl.font = UIFont.systemFont(ofSize: 16)
            bottomLbl.frame = CGRect(x: 25, y: view.si.size.height - 55, width: bottomLbl.intrinsicContentSize.width, height: bottomLbl.intrinsicContentSize.height)
            view.addSubview(bottomLbl)
            view.backgroundColor = UIColor.clear
            }
            .from(view3, transform: makeTransforms([
                translation(-1 * testView.si.size.width, .x),
                translation(0.8 * testView.si.size.height, .y),
                scale(3.5)
                ]))
        
        let view5 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.8, height: screenWidth))
        view5.si.config { (view) in
            view.si.size = CGSize(width: testView.frame.size.width * 0.8, height: testView.frame.size.width * 0.5)
            let lbl = UILabel()
            lbl.frame = CGRect(x: 0, y: 10, width: view.frame.size.width - 20, height: 220)
            lbl.numberOfLines = 0
            lbl.font = UIFont.systemFont(ofSize: 24)
            lbl.text = "It’s a presentation tool inspired by the idea behind prezi.com and based on the power of CSS3 transforms and transitions in modern browsers."
            view.addSubview(lbl)
            view.backgroundColor = UIColor.clear
            }
            .from(view4, transform: makeTransforms([
                translation(0.4 * testView.si.size.height, .y),
                rotation(90),
                scale(1.2)
                ]))
        
        let view6 = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.6, height: screenWidth * 0.8))
        view6.si.config { (view) in
            view.si.size = CGSize(width: testView.frame.size.width * 0.8, height: testView.frame.size.width * 0.5)
            let string = "visualize your\nbig\nthoughts"
            let attributedStr = NSMutableAttributedString(string: string)
            attributedStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 25)], range: NSMakeRange(0, 15))
            attributedStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 75)], range: NSMakeRange(15, 3))
            attributedStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 25)], range: NSMakeRange(18, 9))
            let lbl = UILabel()
            lbl.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 20, height: 220)
            lbl.numberOfLines = 0
            lbl.attributedText = attributedStr
            lbl.textAlignment = .center
            view.addSubview(lbl)
            view.backgroundColor = UIColor.clear
            }
            .from(view5, transform: makeTransforms([
                translation(0.8 * testView.si.size.width, .x),
                rotation(90),
                scale(2)
                ]))
        
        let lbl7: UILabel = UILabel()
        lbl7.si.config { (lbl) in
            lbl.text = "and tiny ideas"
            lbl.si.size = lbl.intrinsicContentSize
            lbl.backgroundColor = UIColor.red
            }.from(view6, transform: makeTransforms([
            translation(10, .x),
            translation(300, .z),
            ]))
        
        testView.config(view1, view2, view3, view4,view5, view6, lbl7)
    }
    
    func impressView(_: ImpressView, endInView view: View) {
//        print("finished step : \(view.tag)")
    }
     

}

