//
//  QHMatrisManager.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHMatrisManager: NSObject {
    
    private weak var superV: UIView!
    private var bAnimation: Bool = false
    private var subV: UIView!
    private var matrisTag: Int = 200
    var currentMatrisArray = [AnyObject]()

//    private let matrisQueue = dispatch_queue_create("com.chen.matris", DISPATCH_QUEUE_CONCURRENT)
    private var matrisRandomListArray = [Array<AnyObject>]()
    
    deinit {
        currentMatrisArray.removeAll()
        matrisRandomListArray.removeAll()
    }
    
    init(superView: UIView, subView: UIView?) {
        superV = superView
        if let sV = subView {
            subV = sV
        }
        else {
            subV = UIImageView.init(frame: CGRectZero)
            subV.backgroundColor = UIColor.redColor()
        }
    }
    
    func addMatrisAnimation(name: String, regionRect: CGRect, image: UIImage?) {
//        dispatch_sync(matrisQueue) { () -> Void in
        ++matrisTag
        if bAnimation == false {
            bAnimation = true
            currentMatrisArray = [name, NSValue.init(CGRect: regionRect), matrisTag]
            self.createMatrisRandom()
        }
        else {
            matrisRandomListArray.append([name, NSValue.init(CGRect: regionRect), matrisTag])
        }
//        }
    }
    
    func createMatrisRandom() {
        let name = currentMatrisArray[0] as! String
        let regionRect = (currentMatrisArray[1] as! NSValue).CGRectValue()
        let matrisTag = currentMatrisArray[2] as! Int
        
        let matrisLocation = QHMatrisLocation.init()
        let (matrisArray, size) = matrisLocation.readFile(name, width: regionRect.size.width, height: regionRect.size.height)
        let matrisRandomArray = QHRandomLocation.getRandomLocationInRegion(matrisArray.count, width: superV.frame.width, height: superV.frame.height)
        
        let fatherView: UIView = UIView.init(frame: subV.bounds)
        fatherView.tag = matrisTag
        fatherView.backgroundColor = UIColor.clearColor()
        for (index, value) in matrisArray.enumerate() {
            let point = value.CGPointValue()
            let pView = QHUtilsMan.duplicateView(subV)
            pView.frame = CGRectMake(point.x + regionRect.origin.x, point.y + regionRect.origin.y, size.width, size.height)
            pView.tag = index + 1
            fatherView.addSubview(pView)
        }
        superV.addSubview(fatherView)
        
        self.animationMatrisRandom(fatherView, matrisRandomArray)
    }
    
    func animationMatrisRandom(superView: UIView, _ matrisRandomArray: Array<NSValue>) {
        for (index, value) in matrisRandomArray.enumerate() {
            if let pView = superView.viewWithTag(index + 1) {
                let point = value.CGPointValue()
                let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "position")
                animation.fromValue = NSValue.init(CGRect: CGRectMake(point.x, point.y, pView.frame.width, pView.frame.height))
                animation.toValue = NSValue.init(CGRect: CGRectMake(pView.center.x, pView.center.y, pView.frame.width, pView.frame.height))
                animation.duration = 1
                animation.fillMode = kCAFillModeForwards
                animation.removedOnCompletion = true
                if (index == matrisRandomArray.count - 1) {
                    animation.delegate = self
                }
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                pView.layer.addAnimation(animation, forKey: "position")
            }
        }
    }
    
    func cleanMatrisRandom() {
        if let arrayTemp: Array<AnyObject> = currentMatrisArray {
            if let fatherView: UIView = self.superV.viewWithTag(arrayTemp[2] as! Int) {
                fatherView.removeFromSuperview()
            }
        }
        if self.matrisRandomListArray.count > 0 {
            currentMatrisArray = matrisRandomListArray.first!
            matrisRandomListArray.removeFirst()
            self.createMatrisRandom()
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
