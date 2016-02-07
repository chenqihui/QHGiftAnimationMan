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
    private var matrisTag: Int = 200
    private var cleanMatrisTag: Int = 200
    private var matrisListArray = [Array<AnyObject>]()
    private var currentMatrisArray = [AnyObject]()
    
    /**是否异步显示，即是否不排队*/
    var bAsync = false
    /**拼成之后的停留时间*/
    var delayInSeconds = 1.0
    
    deinit {
        currentMatrisArray.removeAll()
        matrisListArray.removeAll()
    }
    
    init(superView: UIView) {
        superV = superView
    }
    
    /**
     随机位置显示
     
     - parameter name:    矩阵名称
     - parameter subView: 每个矩阵点的样式
     */
    func addMatrisAnimationRandomLocation(name: String, subView: UIView) {
        
        let x = QHRandomLocation.getRandomNumer(0, to: superV.frame.width)
        let y = QHRandomLocation.getRandomNumer(0, to: superV.frame.height)
        
        self.addMatrisAnimation(name, centerPoint: CGPointMake(x, y), subView: subView)
    }
    
    /**
     指定矩阵的中心位置
     
     - parameter name:        矩阵名称
     - parameter centerPoint: 中心点
     - parameter subView:     每个矩阵点的样式
     */
    func addMatrisAnimation(name: String, centerPoint: CGPoint, subView: UIView) {
        ++matrisTag
        if bAsync == true {
            self.createMatrisRandom(name, centerPoint, matrisTag, subView)
        }
        else {
            if bAnimation == false {
                bAnimation = true
                currentMatrisArray = [name, NSValue.init(CGPoint: centerPoint), matrisTag, subView]
                self.createMatrisRandom()
            }
            else {
                matrisListArray.append([name, NSValue.init(CGPoint: centerPoint), matrisTag, subView])
            }
        }
    }
    
    private func createMatrisRandom() {
        
        let name = currentMatrisArray[0] as! String
        let centerPoint = (currentMatrisArray[1] as! NSValue).CGPointValue()
        let matrisTag = currentMatrisArray[2] as! Int
        let subView = currentMatrisArray[3] as! UIView
        
        self.createMatrisRandom(name, centerPoint, matrisTag, subView)
    }
    
    private func createMatrisRandom(name: String, _ centerPoint: CGPoint, _ matrisTag: Int, _ subView: UIView) {
        
        let matrisLocation = QHMatrisLocation.init()
        let (matrisArray, size) = matrisLocation.readMatrisFile(name, width: subView.frame.width, height: subView.frame.height)
        let x = centerPoint.x - size.width/2
        let y = centerPoint.y - size.height/2
        
        let matrisRandomArray = QHRandomLocation.getRandomLocationInRegion(matrisArray.count, width: superV.frame.width, height: superV.frame.height)
        
        let fatherView: UIView = UIView.init(frame: superV.bounds)
        fatherView.tag = matrisTag
        fatherView.backgroundColor = UIColor.clearColor()
        for (index, value) in matrisArray.enumerate() {
            let point = value.CGPointValue()
            let pView = QHUtilsMan.duplicateView(subView)
            pView.frame = CGRectMake(point.x + x, point.y + y, pView.frame.width, pView.frame.height)
            pView.tag = index + 1
            fatherView.addSubview(pView)
        }
        superV.addSubview(fatherView)
        
        self.animationMatrisRandom(fatherView, matrisRandomArray)
    }
    
    private func animationMatrisRandom(superView: UIView, _ matrisRandomArray: Array<NSValue>) {
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
    
    private func cleanMatrisRandom() {
        if bAsync == true {
            ++cleanMatrisTag
            if let fatherView: UIView = self.superV.viewWithTag(cleanMatrisTag) {
                fatherView.removeFromSuperview()
            }
        }
        else {
            if let arrayTemp: Array<AnyObject> = currentMatrisArray {
                if let fatherView: UIView = self.superV.viewWithTag(arrayTemp[2] as! Int) {
                    fatherView.removeFromSuperview()
                }
            }
            if matrisListArray.count > 0 {
                currentMatrisArray = matrisListArray.first!
                matrisListArray.removeFirst()
                self.createMatrisRandom()
            }
            else {
                bAnimation = false
        }
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.cleanMatrisRandom()
        }
    }
    
    

}
