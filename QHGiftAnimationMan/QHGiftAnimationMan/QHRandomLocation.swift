//
//  QHRandomLocation.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHRandomLocation: NSObject {
    
    class func getRandomLocationInRegion(count: Int, width: CGFloat, height: CGFloat) -> Array<NSValue> {
        
        var randomArray = [NSValue]()
        let region = 4
        let sum = count/region
        let yu = count%region
        var wRange = NSMakeRange(0, 0)
        var hRange = NSMakeRange(0, 0)
        let wRegion = Int(width)/2
        let hRegion = Int(height)/2
        
        for index in 1...region {
            switch index {
            case 1:
                wRange = NSMakeRange(wRegion, wRegion)
                hRange = NSMakeRange(0, hRegion)
            case 2:
                wRange = NSMakeRange(0, wRegion)
                hRange = NSMakeRange(0, hRegion)
            case 3:
                wRange = NSMakeRange(0, wRegion)
                hRange = NSMakeRange(hRegion, hRegion)
            case 4:
                wRange = NSMakeRange(wRegion, wRegion)
                hRange = NSMakeRange(hRegion, hRegion)
            default:
                break
            }
            
            for _ in 1...(index == region ? sum + yu : sum) {
                let x = getRandomNumer(from: CGFloat(wRange.location), to: CGFloat(wRange.location + wRange.length))
                let y = getRandomNumer(from: CGFloat(hRange.location), to: CGFloat(hRange.location + hRange.length))
                randomArray.append(NSValue(cgPoint: CGPoint(x: x, y: y)))
            }
        }
        
        return randomArray
    }
    
    class func getRandomLocation(count: Int, width: CGFloat, height: CGFloat) -> Array<NSValue> {
        
        var randomArray = [NSValue]()
        
        for _ in 1...count {
            let x = getRandomNumer(from: 0, to: UIScreen.main.bounds.width)
            let y = getRandomNumer(from: 0, to: UIScreen.main.bounds.height)
            randomArray.append(NSValue(cgPoint: CGPoint(x: x, y: y)))
        }
        
        return randomArray
    }
    
    class func getRandomNumer(from: CGFloat, to: CGFloat) -> CGFloat {
        return from + CGFloat(arc4random()).truncatingRemainder(dividingBy: (to - from + 1.0))
    }
}
