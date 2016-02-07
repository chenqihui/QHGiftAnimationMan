//
//  ViewController.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var matrisManager: QHMatrisManager?
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        matrisManager = QHMatrisManager.init(superView: contentView, subView: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMatrisAction(sender: AnyObject) {
        let widthView: CGFloat = 200
        matrisManager!.addMatrisAnimation("xiaolian", regionRect: CGRectMake((contentView.frame.width - widthView)/2.0, (contentView.frame.height - widthView)/2.0, widthView, widthView))
    }
    
}

