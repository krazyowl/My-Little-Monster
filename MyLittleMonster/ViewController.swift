//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Jose Gonzales Jr on 10/15/15.
//  Copyright © 2015 Krazyowl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    // Skull Penalty
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!
    
    let dimAlpha: CGFloat = 0.0
    let opaque: CGFloat = 1.0
    let maxPenalty = 3
    
    var penalty = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        skull1Img.alpha = dimAlpha
        skull2Img.alpha = dimAlpha
        skull3Img.alpha = dimAlpha
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        penalty++
        
        if penalty == 1 {
            skull1Img.alpha = opaque
            skull2Img.alpha = dimAlpha
        } else if penalty == 2 {
            skull2Img.alpha = opaque
            skull3Img.alpha = dimAlpha
        } else if penalty >= 3 {
            skull3Img.alpha = opaque
        } else {
            skull1Img.alpha = dimAlpha
            skull2Img.alpha = dimAlpha
            skull3Img.alpha = dimAlpha
        }
        
        if penalty >= maxPenalty {
            gameOver()
        }
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
    }
    
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}

