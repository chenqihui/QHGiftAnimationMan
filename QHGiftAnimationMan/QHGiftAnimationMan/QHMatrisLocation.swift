//
//  QHMatrisLocation.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHMatrisLocation: NSObject {
    
    let matrisValue = "1"
    
    func readMartisFile(name: String, width: CGFloat) -> (Array<NSValue>, CGSize) {
        return self.readMatrisFile(name, width: width, height: width, wSpace: 0, hSpace: 0)
    }
    
    func readMatrisFile(name: String, width: CGFloat, height: CGFloat, wSpace: CGFloat, hSpace: CGFloat) -> (Array<NSValue>, CGSize) {
        
        var matrixArray = [NSValue]()
        var matrixTempArray = [AnyObject]()

        let filePath = NSBundle.mainBundle().pathForResource(name, ofType: nil)
        let contentString = try! String.init(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        
        var length: CGFloat = 0
        
        contentString.enumerateLines({ (line, stop) -> () in
            var matrixLineArray = [AnyObject]()
            let range: Range<String.Index> = Range<String.Index>(start: line.startIndex, end: line.endIndex)
            line.enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, stop) -> () in
                matrixLineArray.append(substring!)
            })
            if (length == 0) {
                length = CGFloat((line as NSString).length)
            }
            matrixTempArray.append(matrixLineArray)
        })
        
        let w = width
        let h = height
        var x: CGFloat = 0// CGFloat(w/2)
        var y: CGFloat = 0// CGFloat(h/2)
        
        for (index, value) in matrixTempArray.enumerate() {
            let array = value as! Array<String>
            for (_, val) in array.enumerate() {
                if (val == matrisValue) {
                    matrixArray.append(NSValue.init(CGPoint: CGPointMake(x, y)))
                }
                x += w + wSpace
            }
            if index != matrixTempArray.count - 1 {
                x = 0// CGFloat(w/2)
            }
            y += h + hSpace
        }
        
        return (matrixArray, CGSizeMake(x, y))
    }

}
