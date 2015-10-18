//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Jose Gonzales Jr on 10/15/15.
//  Copyright © 2015 Krazyowl. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    // Skull Penalty
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!
    
    let dimAlpha: CGFloat = 0.1
    let opaque: CGFloat = 1.0
    let maxPenalty = 3
    
    var penalty = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        skull1Img.alpha = dimAlpha
        skull2Img.alpha = dimAlpha
        skull3Img.alpha = dimAlpha
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = dimAlpha
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = dimAlpha
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            
            sfxHeart.play()
            
        } else {
            
            sfxBite.play()
        }
        
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            
            penalty++
            
            sfxSkull.play()
            
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
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImg.alpha = dimAlpha
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = opaque
            heartImg.userInteractionEnabled = true
        } else {
            
            heartImg.alpha = dimAlpha
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = opaque
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
    
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}

