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
    
    @IBOutlet weak var gameView: BezierPathsView!

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
    let bricksPerRow = 4
    let numberOfRows = 6
    let brickPadding = 5
    var paddle: PaddleView? {
        didSet {
            if paddle != nil {
                gameView?.addGestureRecognizer(UIPanGestureRecognizer(target: paddle!, action: "move:"))
            }
        }
    }
    var balls = [BallView]()
    var bricks = [Int:BrickView]()
    var lastCollidedItem: NSCopying?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //rect.size.height *= 2
        breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: PathNames.BoxBarrier)
        
        let bottomBarrierOrigin = CGPoint(x: 0, y: gameView.bounds.size.height)
        let bottomBarrierSize = CGSize(width: gameView.bounds.size.width, height: 1)
        breakoutBehavior.addBarrier(UIBezierPath(rect: CGRect(origin: bottomBarrierOrigin, size: bottomBarrierSize)), named: PathNames.BottomBarrier)
    }
    
    var brickSize: CGSize {
        let width = (gameView.bounds.size.width / CGFloat(bricksPerRow)) - CGFloat(2 * brickPadding )
        let height = (gameView.bounds.size.height / 3 / CGFloat(numberOfRows)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }
    
    func reloadGame() {
        self.removePaddle()
        self.removeBricks()
        self.removeBalls()
        self.loadGame()
    }
    
    func removePaddle() {
        self.paddle?.removeFromSuperview()
        self.paddle = nil
    }
    
    func removeBricks() {
        for var i = 0; i < self.bricks.count; i++ {
            if let brick = self.bricks[i] {
                brick.removeFromSuperview()
                self.breakoutBehavior.removeBrick(brick)
                self.breakoutBehavior.removeBarrier(named: i)
            }
        }
        self.bricks.removeAll(keepCapacity: true)
    }
    
    func removeBalls() {
        for ball in self.balls {
            ball.removeFromSuperview()
            self.breakoutBehavior.removeBall(ball)
        }
        self.balls.removeAll(keepCapacity: false)
    }
    
    func loadGame() {
        self.addBricks()
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
            var ball = BallView(gameFrame: gameView.bounds.size, maxWidth: CGFloat(settings.ballSpeed!))
            ball.backgroundColor = UIColor.orangeColor()
            self.breakoutBehavior.addBall(ball)
            self.breakoutBehavior.pushBall(ball)
            self.balls.append(ball)
        }
        
        if !balls.isEmpty {
            gameView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "push:"))
        }
    }
    
    func addBricks() {
        for var rowNumber = 0; rowNumber < numberOfRows; rowNumber++ {
            addRow(rowNumber)
        }
    }
    
    func push(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            for ball in self.balls {
                self.breakoutBehavior.pushBall(ball)
            }
        }
    }
    
    func addRow(rowNumber: Int) {
        let size = brickSize
        for var brickNumber = 0; brickNumber < bricksPerRow; brickNumber++ {
            let x = (CGFloat(brickNumber) * (size.width + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
            let y = (CGFloat(rowNumber) * (size.height + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
            let origin = CGPoint(x: x, y: y)
            let brick = BrickView(frame: CGRect(origin: origin, size: size))
            brick.backgroundColor = UIColor.random
            
            let brickId = brickNumber + (bricksPerRow * rowNumber)
            bricks[brickId] = brick
            breakoutBehavior.addBarrier(UIBezierPath(roundedRect: brick.frame, cornerRadius: 0), named: brickId)
            self.breakoutBehavior.addBrick(brick)
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if(identifier !== lastCollidedItem || lastCollidedItem === nil) {
            lastCollidedItem = identifier
            if let index = identifier as? Int {
                removeBrickAtIndex(index)
            } else if let pathName = identifier as? String {
                if pathName == PathNames.BottomBarrier {
                    println("You lost the game!")
                }
            }
        }
    }
    
    func removeBrickAtIndex(index: Int) {
        if let brick = bricks[index] {
            breakoutBehavior.removeBrick(brick)
            breakoutBehavior.removeBarrier(named: index)
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}

