//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIBreakoutDelegate {
    
    private var settings: BreakoutSettings? {
        didSet {
            if settings != nil {
                self.gameView?.ballWidth = self.settings!.ballWidth!
                self.gameView?.ballSpeed = self.settings!.ballSpeed!
                self.gameView?.numberOfBalls = self.settings!.numberOfBalls!
                self.gameView?.paddleWidth = self.settings!.paddleWidth!
                self.gameView?.theme = self.settings!.selectedTheme!
            }
        }
    }
    
    @IBOutlet weak var gameView: BreakoutView!
    @IBOutlet weak var livesLabel: UILabel!
    
    var lives: Int {
        get {
            return livesLabel!.text!.toInt()!
        }
        set {
            livesLabel?.text = "\(newValue)"
        }
    }

        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameView.breakoutDelegate = self
        self.settings = BreakoutSettings.load()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.gameView.gameState == .Initial {
            self.gameView.preloadGame()
            self.gameView.loadGame()
        } else if self.gameView.gameState == .Paused {
            let newSettings = BreakoutSettings.load()
            if settings?.description != newSettings.description {
                settings = newSettings
                self.gameView.reloadGame()
            } else {
                //TODO: Unpause the game
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.gameView.pauseGame()
    }
    
    func onBrickHit(brickHealth: Int) {
        //TODO: Implement scoring system
    }
    
    func onLivesChanged(newLives: Int) {
        self.lives = newLives
    }
    
    func onLevelCompleted() {
        let gameWon = self.gameView.tryLoadNextLevel()
        if gameWon {
            //TODO: Show an alert so the player can restart the game
            println("You won the game!")
        }
    }
    
}

