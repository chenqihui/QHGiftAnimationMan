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
        matrisManager = QHMatrisManager.init(superView: contentView)
        matrisManager?.bAsync = true
        matrisManager?.delayInSeconds = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMatrisAction(sender: AnyObject) {
        let widthView: CGFloat = 20
        let subView: UIView = UIView.init(frame: CGRectMake(0, 0, widthView, widthView))
        subView.backgroundColor = UIColor.orangeColor()
        subView.layer.cornerRadius = widthView/2
        
        let image = UIImage.init(named: QHRandomLocation.getRandomNumer(0, to: 1) == 0 ? "cao" : "hua")
        let subImageView = UIImageView.init(frame: CGRectMake(0, 0, widthView, widthView))
        subImageView.image = image
        
//        matrisManager!.addMatrisAnimation("xiaolian", centerPoint: contentView.center, subView: subImageView)
        
        matrisManager!.addMatrisAnimationRandomLocation(QHRandomLocation.getRandomNumer(0, to: 1) == 0 ? "xiaolian" : "diao", subView: subImageView)
    }
    
}

