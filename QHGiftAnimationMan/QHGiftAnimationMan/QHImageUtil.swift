//
//  QHImageUtil.swift
//  QHGiftAnimationMan
//
//  Created by Anakin chen on 2019/1/15.
//  Copyright © 2019 chen. All rights reserved.
//

import UIKit
import CoreGraphics

class QHImageUtil: NSObject {
    
    // [extract pixel from a CGImage](https://gist.github.com/jokester/948616a1b881451796d6)
    // [【IOS】图片二值化和黑白(灰度)处理 - 简书](https://www.jianshu.com/p/c962403cae65)
    // [ColorMatcher_ios/PixelExtractor.swift at 58257833e5dffb2a8b35e027a5caa3963c0145cc · SimonVL01/ColorMatcher_ios](https://github.com/SimonVL01/ColorMatcher_ios/blob/58257833e5dffb2a8b35e027a5caa3963c0145cc/ColorMatcher/PixelExtractor.swift)
    
    
    // taken from http://stackoverflow.com/questions/24049313/
    // and adapted to swift 1.2
    let image: CGImage
    var context: CGContext?
    
    var width: Int {
        get {
            return image.width
        }
    }
    
    var height: Int {
        get {
            return image.height
        }
    }
    
    init(img: CGImage) {
        image = img
        context = QHImageUtil.create_bitmap_context(img: img)
    }
    
    private class func create_bitmap_context(img: CGImage) -> CGContext? {
        
        // Get image width, height
        let pixelsWide = img.width
        let pixelsHigh = img.height
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        if let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
        
            // draw the image onto the context
            let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
            context.draw(img, in: rect)
            
            return context
        }
        return nil
    }
    
    func color_at(x: Int, y: Int)->UIColor? {

        guard let c = context else {
            return nil
        }

        assert(0<=x && x<width)
        assert(0<=y && y<height)

//        let uncasted_data = c.data
//        let data = UnsafeMutablePointer<UInt8>(uncasted_data)
        // [iOS中的CGBitmapContext - 简书](https://www.jianshu.com/p/84addd11e679)
        let data = unsafeBitCast(c.data, to: UnsafeMutablePointer<UInt8>.self)

        let offset = 4 * (y * width + x)

        let alpha = data[offset]
        let red = data[offset+1]
        let green = data[offset+2]
        let blue = data[offset+3]

        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)

        return color
    }
    
    func grayData(space: UInt) {
        
        guard let c = context else {
            return
        }
        
        let ss = Int(max(space, 1))
        
        var matrixBitmap: String = ""
        let data = unsafeBitCast(c.data, to: UnsafeMutablePointer<UInt8>.self)
        for y in 0..<height {
            // [Swift - 如何对浮点数进行取余（取模）](http://www.hangge.com/blog/cache/detail_1457.html)
            if y%ss == 0 {
                var matrixLine: String = ""
                for x in 0..<width {
                    let offset = 4 * (y * width + x)
                    
//                    let alpha = data[offset]
                    let red = data[offset+1]
                    let green = data[offset+2]
                    let blue = data[offset+3]
                    
                    let value = (CGFloat(red) + CGFloat(green) + CGFloat(blue)) / CGFloat(3.0) / CGFloat(255.0)
                    
                    if x%ss == 0 {
                        if value < 0.5 {
                            matrixLine += "1"
                        }
                        else {
                            matrixLine += "0"
                        }
                    }
                }
                matrixBitmap += matrixLine + "\n"
            }
        }
        
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let filePath = "\(path)/binarydata"
            do {
                try matrixBitmap.write(toFile: filePath, atomically: true, encoding: .utf8)
            }
            catch {
                print("保存失败")
            }
            print("保存地址=\(filePath)")
        }
    }
    
    func grayImage() -> UIImage? {
        
        guard let c = context else {
            return nil
        }
        
        let data = unsafeBitCast(c.data, to: UnsafeMutablePointer<UInt8>.self)
        for y in 0..<height {
            for x in 0..<width {
                let offset = 4 * (y * width + x)
                
                //                    let alpha = data[offset]
                let red = data[offset+1]
                let green = data[offset+2]
                let blue = data[offset+3]
                
                let value = (CGFloat(red) + CGFloat(green) + CGFloat(blue)) / CGFloat(3.0) / CGFloat(255.0)
                
                var bp: UInt8 = 0
                if value >= 0.5 {
                    bp = 255
                }
                data[offset+1] = bp
                data[offset+2] = bp
                data[offset+3] = bp
            }
        }
        
        if let cgi = context?.makeImage() {
            let i = UIImage(cgImage: cgi)
            return i
        }
        return nil
    }

    func path() -> String? {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let filePath = "\(path)/binarydata"
            if FileManager.default.fileExists(atPath: filePath) == true {
                return filePath
            }
        }
        return nil
    }

}
