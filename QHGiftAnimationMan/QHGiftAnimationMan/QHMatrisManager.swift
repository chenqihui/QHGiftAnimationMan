//
//  QHMatrisManager.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHMatrisManager: NSObject, CAAnimationDelegate {
    
    private weak var superV: UIView!
    private var bAnimation: Bool = false
    private var matrisTag: Int = 200
    private var cleanMatrisTag: Int = 200
    private var matrisListArray = [Array<Any>]()
    private var currentMatrisArray = [Any]()
    
    /// 是否异步显示，即是否不排队
    var bAsync = false
    /// 拼成之后的停留时间，为小于等于0时，表示不删除动画
    var delayInSeconds = 1.0
    /// 左边间隙
    var wSpace: CGFloat = 0.0
    /// 上边间隙
    var hSpace: CGFloat = 0.0
    
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
        
        let x = QHRandomLocation.getRandomNumer(from: 0, to: superV.frame.width)
        let y = QHRandomLocation.getRandomNumer(from: 0, to: superV.frame.height)
        
        self.addMatrisAnimation(name: name, centerPoint: CGPoint(x: x, y: y), subView: subView)
    }
    
    /**
     指定矩阵的中心位置
     
     - parameter name:        矩阵名称
     - parameter centerPoint: 中心点
     - parameter subView:     每个矩阵点的样式
     */
    func addMatrisAnimation(name: String, centerPoint: CGPoint, subView: UIView) {
        matrisTag+=1
        if bAsync == true {
            self.createMatrisRandom(name: name, centerPoint, matrisTag, subView)
        }
        else {
            if bAnimation == false {
                bAnimation = true
                currentMatrisArray = [name, NSValue.init(cgPoint: centerPoint), matrisTag, subView, false]
                self.createMatrisRandom()
            }
            else {
                matrisListArray.append([name, NSValue(cgPoint: centerPoint), matrisTag, subView, false])
            }
        }
    }
    
    func addMatrisAnimation(filePath: String, centerPoint: CGPoint, subView: UIView) {
        matrisTag+=1
        if bAsync == true {
            self.createMatrisRandom(filePath: filePath, centerPoint, matrisTag, subView)
        }
        else {
            if bAnimation == false {
                bAnimation = true
                currentMatrisArray = [filePath, NSValue.init(cgPoint: centerPoint), matrisTag, subView, true]
                self.createMatrisRandom()
            }
            else {
                matrisListArray.append([filePath, NSValue(cgPoint: centerPoint), matrisTag, subView, true])
            }
        }
    }
    
    private func createMatrisRandom() {
        
        let name = currentMatrisArray[0] as! String
        let centerPoint = (currentMatrisArray[1] as! NSValue).cgPointValue
        let matrisTag = currentMatrisArray[2] as! Int
        let subView = currentMatrisArray[3] as! UIView
        let b = currentMatrisArray[4] as! Bool
        if b == true {
            self.createMatrisRandom(filePath: name, centerPoint, matrisTag, subView)
        }
        else {
            self.createMatrisRandom(name: name, centerPoint, matrisTag, subView)
        }
    }
    
    private func createMatrisRandom(name: String, _ centerPoint: CGPoint, _ matrisTag: Int, _ subView: UIView) {
        if let filePath = Bundle.main.path(forResource: name, ofType: nil) {
            createMatrisRandom(filePath: filePath, centerPoint, matrisTag, subView)
        }
    }
    
    private func createMatrisRandom(filePath: String, _ centerPoint: CGPoint, _ matrisTag: Int, _ subView: UIView) {
        
        let matrisLocation = QHMatrisLocation.init()
        let (matrisArray, size) = matrisLocation.readMatrisFile(filePath: filePath, width: subView.frame.width, height: subView.frame.height, wSpace: wSpace, hSpace: hSpace)
        let x = centerPoint.x - size.width/2
        let y = centerPoint.y - size.height/2
        
        let matrisRandomArray = QHRandomLocation.getRandomLocationInRegion(count: matrisArray.count, width: superV.frame.width, height: superV.frame.height)
        
        let fatherView: UIView = UIView.init(frame: superV.bounds)
        fatherView.tag = matrisTag
        fatherView.backgroundColor = UIColor.clear
        for (index, value) in matrisArray.enumerated() {
            let point = value.cgPointValue
            let pView = QHUtilsMan.duplicateView(view: subView)
            pView.frame = CGRect(x: point.x + x, y: point.y + y, width: pView.frame.width, height: pView.frame.height)
            pView.tag = index + 1
            fatherView.addSubview(pView)
        }
        superV.addSubview(fatherView)
        
        self.animationMatrisRandom(superView: fatherView, matrisRandomArray)
    }
    
    private func animationMatrisRandom(superView: UIView, _ matrisRandomArray: Array<NSValue>) {
        for (index, value) in matrisRandomArray.enumerated() {
            if let pView = superView.viewWithTag(index + 1) {
                let point = value.cgPointValue
                let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "position")
                animation.fromValue = NSValue(cgRect: CGRect(x: point.x, y: point.y, width: pView.frame.width, height: pView.frame.height))
                animation.toValue = NSValue(cgRect: CGRect(x: pView.center.x, y: pView.center.y, width: pView.frame.width, height: pView.frame.height))
                animation.duration = 1
                animation.fillMode = CAMediaTimingFillMode.forwards
                animation.isRemovedOnCompletion = true
                if (index == matrisRandomArray.count - 1 && delayInSeconds > 0) {
                    animation.delegate = self
                }
                animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                pView.layer.add(animation, forKey: "position")
            }
        }
    }
    
    private func cleanMatrisRandom() {
        if bAsync == true {
            cleanMatrisTag+=1
            if let fatherView: UIView = self.superV.viewWithTag(cleanMatrisTag) {
                fatherView.removeFromSuperview()
            }
        }
        else {
            if currentMatrisArray.count > 2 {
                if let fatherView: UIView = self.superV.viewWithTag(currentMatrisArray[2] as! Int) {
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
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) { [weak self] in
            self?.cleanMatrisRandom()
        }
    }
    
    

}
