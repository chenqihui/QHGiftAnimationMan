//
//  ViewController.swift
//  QHGiftAnimationMan
//
//  Created by chen on 16/2/5.
//  Copyright © 2016年 chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var matrisManager: QHMatrisManager!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        matrisManager = QHMatrisManager.init(superView: contentView)
        matrisManager.bAsync = true
        matrisManager.delayInSeconds = 6
        matrisManager.wSpace = -6
        matrisManager.hSpace = -6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMatrisAction(_ sender: Any) {
//        let widthView: CGFloat = QHRandomLocation.getRandomNumer(from: 12, to: 22)
//        let image = UIImage.init(named: QHRandomLocation.getRandomNumer(from: 0, to: 1) == 0 ? "cao" : "hua")
//        let subImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: widthView, height: widthView))
//        subImageView.image = image
        
//        matrisManager!.addMatrisAnimation(name: "xiaolian2", centerPoint: contentView.center, subView: subImageView)
        
//        matrisManager!.addMatrisAnimationRandomLocation(name: QHRandomLocation.getRandomNumer(from: 0, to: 1) == 0 ? "xiaolian" : "diao", subView: subImageView)
        
        let widthView: CGFloat = 10
        let image = UIImage.init(named: "hua")
        let subImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: widthView, height: widthView))
        subImageView.image = image
        matrisManager!.addMatrisAnimation(name: "ttt", centerPoint: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2), subView: subImageView)
        //        matrisManager!.addMatrisAnimationRandomLocation(name: "ttt", subView: subImageView)
    }
    
}

