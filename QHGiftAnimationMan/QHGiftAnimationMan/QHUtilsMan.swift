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
        let tempArchive = NSKeyedArchiver.archivedData(withRootObject: view)
        return NSKeyedUnarchiver.unarchiveObject(with: tempArchive) as! UIView
    }

}
