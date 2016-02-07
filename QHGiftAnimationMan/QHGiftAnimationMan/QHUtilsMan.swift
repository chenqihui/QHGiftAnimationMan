//
//  QHUtilsMan.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/7.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class QHUtilsMan: NSObject {
    
    class func duplicateView(view: UIView) -> (UIView) {
        let tempArchive = NSKeyedArchiver.archivedDataWithRootObject(view)
        return NSKeyedUnarchiver.unarchiveObjectWithData(tempArchive) as! UIView
    }

}
