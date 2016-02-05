//
//  QHMatrisManager.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHMatrisManager: NSObject {
    
    private weak var superV: UIView?
    private var count: Int = 1
    private var bAnimation: Bool = false

//    private let matrisQueue = dispatch_queue_create("com.chen.matris", DISPATCH_QUEUE_CONCURRENT)
    private var matrisRandomListArray = [Array<AnyObject>]()
    
    deinit {
        matrisRandomListArray.removeAll()
    }
    
    init(superView: UIView) {
        superV = superView
    }
    
    func addMatrisRandom(name: String, regionRect: CGRect) {
//        dispatch_sync(matrisQueue) { () -> Void in
            self.matrisRandomListArray.append([name, NSValue.init(CGRect: regionRect)])
            if self.bAnimation == false {
                self.bAnimation = true
                self.createMatrisRandom(name, regionRect: regionRect)
            }
//        }
    }
    
    func createMatrisRandom(name: String, regionRect: CGRect) {
        let matrisLocation = QHMatrisLocation.init()
        let (matrisArray, size) = matrisLocation.readFile(name, width: regionRect.size.width, height: regionRect.size.height)
        count = matrisArray.count
        let matrisRandomArray = QHRandomLocation.getRandomLocationInRegion(count, width: superV!.frame.width, height: superV!.frame.height)
        
        for (index, value) in matrisArray.enumerate() {
            let point = value.CGPointValue()
            let pView = UIView.init(frame: CGRectMake(point.x + regionRect.origin.x, point.y + regionRect.origin.y, size.width, size.height))
            pView.backgroundColor = UIColor.redColor()
            pView.layer.cornerRadius = pView.frame.width/2
            pView.tag = index + 1;
            superV!.addSubview(pView)
        }
        
        self.animationMatrisRandom(superV!, matrisRandomArray: matrisRandomArray)
    }
    
    func animationMatrisRandom(superView: UIView, matrisRandomArray: Array<NSValue>) {
        for (index, value) in matrisRandomArray.enumerate() {
            if let pView = superView.viewWithTag(index + 1) {
                let point = value.CGPointValue()
                let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "position")
                animation.fromValue = NSValue.init(CGRect: CGRectMake(point.x, point.y, pView.frame.width, pView.frame.height))
                animation.toValue = NSValue.init(CGRect: CGRectMake(pView.center.x, pView.center.y, pView.frame.width, pView.frame.height))
                animation.duration = 1
                animation.fillMode = kCAFillModeForwards
                animation.removedOnCompletion = true
                if (index == count - 1) {
                    animation.delegate = self
                }
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                pView.layer.addAnimation(animation, forKey: "position")
            }
        }
    }
    
    func cleanMatrisRandom() {
        for index in 1...self.count {
            if let pView: UIView = self.superV!.viewWithTag(index) {
                pView.layer.removeAllAnimations()
                pView.removeFromSuperview()
            }
        }
        self.matrisRandomListArray.removeFirst()
        if self.matrisRandomListArray.count > 0 {
            if let arrayTemp: Array<AnyObject> = self.matrisRandomListArray.first {
                self.createMatrisRandom(arrayTemp[0] as! String, regionRect: (arrayTemp[1] as! NSValue).CGRectValue())
            }
        }
        else {
            bAnimation = false
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let delayInSeconds = 1.0
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.cleanMatrisRandom()
        }
    }

}
