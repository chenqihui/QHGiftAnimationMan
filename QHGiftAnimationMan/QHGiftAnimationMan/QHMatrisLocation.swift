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
        return self.readMatrisFile(name: name, width: width, height: width, wSpace: 0, hSpace: 0)
    }
    
    func readMatrisFile(name: String, width: CGFloat, height: CGFloat, wSpace: CGFloat, hSpace: CGFloat) -> (Array<NSValue>, CGSize) {
        let filePath = Bundle.main.path(forResource: name, ofType: nil)
        return readMatrisFile(filePath: filePath!, width: width, height: height, wSpace: wSpace, hSpace: hSpace)
    }
    
    func readMatrisFile(filePath: String, width: CGFloat, height: CGFloat, wSpace: CGFloat, hSpace: CGFloat) -> (Array<NSValue>, CGSize) {
        
        var matrixArray = [NSValue]()
        var matrixTempArray = [Any]()

            
        let contentString = try! String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        
        var length: CGFloat = 0
        
        contentString.enumerateLines(invoking: { (line, stop) -> () in
            var matrixLineArray = [Any]()
            let wholeString = line.startIndex..<line.endIndex
            line.enumerateSubstrings(in: wholeString, options: .byComposedCharacterSequences) {
                (substring, range, enclosingRange, stopPointer) in
                if let s = substring {
                    matrixLineArray.append(s)
                }
            }
            if (length == 0) {
                length = CGFloat((line as NSString).length)
            }
            matrixTempArray.append(matrixLineArray)
        })
        
        let w = width
        let h = height
        var x: CGFloat = 0// CGFloat(w/2)
        var y: CGFloat = 0// CGFloat(h/2)
        
        for (index, value) in matrixTempArray.enumerated() {
            let array = value as! Array<String>
            for (_, val) in array.enumerated() {
                if (val == matrisValue) {
                    matrixArray.append(NSValue(cgPoint: CGPoint(x: x, y: y)))
                }
                x += w + wSpace
            }
            if index != matrixTempArray.count - 1 {
                x = 0// CGFloat(w/2)
            }
            y += h + hSpace
        }
        
        return (matrixArray, CGSize(width: x, height: y))
    }

}
