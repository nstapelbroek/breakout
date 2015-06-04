//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    private var settings = BreakoutSettings.load()
    
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

    enum GameState: Int {
        case Initial = 0, Loaded, Playing, Paused, Finished
    }

    struct PathNames {
        static let BoxBarrier = "Box"
        static let BottomBarrier = "Bottom"
        static let PaddleBarrier = "Paddle"
    }
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamitAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamitAnimator.delegate = self
        return lazilyCreatedDynamitAnimator
        }()
    
    let breakoutBehavior = BreakoutBehavior()
    var gameState = GameState.Initial
    var paddle: PaddleView? {
        didSet {
            if paddle != nil {
                self.panGesture = UIPanGestureRecognizer(target: paddle!, action: "move:")
                gameView?.addGestureRecognizer(self.panGesture!)
            }
        }
    }
    var balls = [BallView]()
    var lastCollidedItem: NSCopying?
    private var panGesture: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameView.breakoutBehavior = self.breakoutBehavior
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if gameState == .Initial {
            loadGame()
            gameState = .Loaded
        } else if gameState == .Paused {
            let newSettings = BreakoutSettings.load()
            if settings.description != newSettings.description {
                settings = newSettings
                self.reloadGame()
                gameState = .Loaded
            } else {
                //TODO: Unpause the game
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //TODO: Pause the game
        gameState = GameState.Paused
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var rect = gameView.bounds
        //Double the height to make the ball disappear when it hits the bottom of the screen
        rect.size.height *= CGFloat(1 + 1.5 * settings.ballWidth!)
        breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: PathNames.BoxBarrier)
        
        let bottomBarrierOrigin = CGPoint(x: 0, y: rect.size.height)
        let bottomBarrierSize = CGSize(width: gameView.bounds.size.width, height: 1)
        breakoutBehavior.addBarrier(UIBezierPath(rect: CGRect(origin: bottomBarrierOrigin, size: bottomBarrierSize)), named: PathNames.BottomBarrier)
    }
    
    func reloadGame() {
        self.removePaddle()
        self.gameView.removeBricks()
        self.removeBalls()
        self.loadGame()
    }
    
    func removePaddle() {
        self.paddle?.removeFromSuperview()
        self.gameView.removeGestureRecognizer(self.panGesture!)
        self.panGesture = nil
        self.paddle = nil
    }
    
    func removeBalls() {
        for ball in self.balls {
            ball.removeFromSuperview()
            self.breakoutBehavior.removeBall(ball)
        }
        self.balls.removeAll(keepCapacity: false)
    }
    
    func loadGame() {
        self.gameView.addBricks()
        self.addPaddle()
        self.addBalls()
    }

    func addPaddle() {
        paddle = PaddleView(gameFrame: gameView.bounds.size, maxWidth: CGFloat(settings.paddleWidth!))
        paddle?.backgroundColor = UIColor.blackColor()
        breakoutBehavior.addBarrier(UIBezierPath(rect: paddle!.frame), named: PathNames.PaddleBarrier)
        self.breakoutBehavior.addPaddle(paddle!)
        paddle!.setBreakoutBehavior(breakoutBehavior, withPathName: PathNames.PaddleBarrier)
    }
    
    func addBalls() {
        for var i = 0; i < settings.numberOfBalls!; i++
        {
            addBall()
        }
        
        if !balls.isEmpty {
            gameView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "push:"))
        }
    }
    
    func addBall() {
        var ball = BallView(gameFrame: gameView.bounds.size, maxWidth: CGFloat(settings.ballWidth!))
        ball.backgroundColor = UIColor.orangeColor()
        self.breakoutBehavior.addBall(ball)
        self.breakoutBehavior.pushBall(ball, magnitude: settings.ballSpeed!)
        self.balls.append(ball)
    }
    
    
    
    func push(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            for ball in self.balls {
                self.breakoutBehavior.pushBall(ball, magnitude: settings.ballSpeed!)
            }
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if(identifier !== lastCollidedItem || lastCollidedItem === nil) {
            lastCollidedItem = identifier
            if let index = identifier as? Int {
                let brick = self.gameView.bricks[index]
                brick!.setNewHealth(brick!.health - 1)
                if brick?.health <= 0 {
                    self.gameView.removeBrickAtIndex(index)
                    self.gameView.bricks.removeValueForKey(index)
                    
                    if self.gameView.bricks.count == 0 {
                        self.gameView.currentLevel++
                        self.reloadGame()
                    }
                }
            } else if let pathName = identifier as? String {
                if pathName == PathNames.BottomBarrier {
                    if let ball = item as? BallView {
                        if let index = find(self.balls, ball) {
                            self.balls.removeAtIndex(index)
                            self.breakoutBehavior.removeBall(ball)
                        }
                    }
                    
                    if self.lives == 0 && self.balls.count == 0 {
                        println("You lost the game!")
                    } else if self.lives > 0 {
                        self.lives--
                        addBall()
                    }
                    
                }
            }
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

