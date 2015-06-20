//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit
import CoreMotion

class BreakoutViewController: UIViewController, UIBreakoutDelegate {
    
    private var settings: BreakoutSettings? {
        didSet {
            if settings != nil {
                self.accelerometerEnabled = self.settings!.accelerometerEnabled!
                self.gameView?.ballWidth = self.settings!.ballWidth!
                self.gameView?.ballSpeed = self.settings!.ballSpeed!
                self.gameView?.numberOfBalls = self.settings!.numberOfBalls!
                self.gameView?.paddleWidth = self.settings!.paddleWidth!
                self.gameView?.theme = self.settings!.selectedTheme!
            }
        }
    }
    
    private var restartAlert = UIAlertController (
        title: "Title",
        message: "Do you want to restart the game?",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    private var pauseAlert = UIAlertController (
        title: "Game paused",
        message: "Tab the button below to resume",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    
    @IBOutlet weak var gameView: BreakoutView!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var countdown : Int! = 0
    var countdownTimer = NSTimer()
    
    var lives: Int {
        get {
            return livesLabel!.text!.toInt()!
        }
        set {
            livesLabel?.text = "\(newValue)"
        }
    }
    
    let manager = CMMotionManager()
    var accelerometerEnabled = false {
        didSet {
            if self.accelerometerEnabled {
                if manager.deviceMotionAvailable {
                    manager.deviceMotionUpdateInterval = 0.01
                    manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                        [weak self] (data: CMAccelerometerData!, error: NSError!) in
                        self!.gameView!.movePaddleBy(CGPoint(x: 20.0 * data.acceleration.x , y: 0.0))
                    }
                }
            } else {
                if manager.deviceMotionAvailable {
                    manager.stopAccelerometerUpdates()
                }
            }
        }
    }


        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameView.breakoutDelegate = self
        self.settings = BreakoutSettings.load()
        self.restartAlert.addAction(UIAlertAction(
            title: "Restart",
            style: .Default)
            { (action UIAlertAction) -> Void in
                self.restartGame()
            }
        )
        
        self.pauseAlert.addAction(UIAlertAction(
            title: "Continue",
            style: .Default,
            handler: { (action UIAlertAction) -> Void in self.unPauseGame() })
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.gameView.gameState == .Initial {
            self.gameView.preloadGame()
            self.gameView.loadGame()
            self.pauseAlert.title = "Ready, Set, Go!"
            self.presentViewController(self.pauseAlert, animated: true, completion: nil)
        } else if self.gameView.gameState == .Paused {
            let newSettings = BreakoutSettings.load()
            if settings?.description != newSettings.description {
                settings = newSettings
                self.gameView.reloadGame()
                self.pauseAlert.title = "Game reloaded"
                self.presentViewController(self.pauseAlert, animated: true, completion: nil)
            } else {
                self.pauseAlert.title = "Game paused"
                self.presentViewController(self.pauseAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if(countdownTimer.valid) {
            countdownTimer.invalidate()
        }
        self.gameView.pauseGame()
    }
    
    
    func unPauseGame() {
        countdown = 3
        countdownLabel.text = "Game starting in: \(countdown)"
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown:"), userInfo: nil, repeats: true)
    }
    
    func countDown(timer: NSTimer) {
        countdown = countdown - 1
        countdownLabel.text = "Game starting in: \(countdown)"
        if(countdown <= 0) {
            self.gameView.startGame()
            countdownTimer.invalidate()
            countdownLabel.text = ""
        }
    }
    
    func restartGame() {
        self.gameView.restartGame()
        self.unPauseGame()
    }
    
    func onBrickHit(brickHealth: Int) {
        //TODO: Implement scoring system
    }
    
    func onLivesChanged(newLives: Int) {
        self.lives = newLives
        if self.lives == 0 && self.gameView.balls.count == 0 {
            self.gameView.pauseGame()
            self.restartAlert.title = "You lost the game!"
            self.presentViewController(self.restartAlert, animated: true, completion: nil)
        }
    }
    
    func onLevelCompleted() {
        let gameWon = self.gameView.tryLoadNextLevel()
        if gameWon {
            self.gameView.pauseGame()
            self.restartAlert.title = "You won the game!"
            self.presentViewController(self.restartAlert, animated: true, completion: nil)
        } else {
            self.pauseAlert.title = "Level up!"
            self.presentViewController(self.pauseAlert, animated: true, completion: nil)
        }
    }
    
}

