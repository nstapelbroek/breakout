//
//  BezierPathsView.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

protocol UIBreakoutDelegate: class {
    func onBrickHit(brickHealth: Int)
    func onLivesChanged(newLives: Int)
    func onLevelCompleted()
}

@IBDesignable
class BreakoutView: UIView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    // MARK: - Behavior variables
    let breakoutBehavior = BreakoutBehavior()
    struct PathNames {
        static let BoxBarrier = "Box"
        static let BottomBarrier = "Bottom"
        static let PaddleBarrier = "Paddle"
    }
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamitAnimator = UIDynamicAnimator(referenceView: self)
        lazilyCreatedDynamitAnimator.delegate = self
        return lazilyCreatedDynamitAnimator
        }()
    
    // MARK: - Gamestate variables
    enum GameState: Int {
        case Initial = 0, Loaded, Playing, Paused, Finished
    }
    var gameState = GameState.Initial
    static let initialLives = 5
    var lives = BreakoutView.initialLives {
        didSet {
            if let delegate = self.breakoutDelegate {
                delegate.onLivesChanged(self.lives)
            }
        }
    }
    var lastCollidedItem: NSCopying?
    var breakoutDelegate: UIBreakoutDelegate?
    
    // MARK: - Level variables
    var currentLevel = 0
    private let levels = [
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:",
        
        "2,2,2,2:" +
        "1,1,1,1:" +
        "2,2,2,2:" +
        "1,1,1,1:" +
        "2,2,2,2:" +
        "1,1,1,1:",
        
        "0,1,2,1,0:" +
        "1,0,1,0,1:" +
        "2,1,2,1,2:" +
        "1,2,1,2,1:" +
        "2,0,2,0,2:" +
        "0,1,2,1,0:",
        
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:",
        
        "3,3,3,3,3:" +
        "3,2,2,2,3:" +
        "3,2,3,2,3:" +
        "3,2,3,2,3:" +
        "3,2,2,2,3:" +
        "3,3,3,3,3:"
    ]
    
    // MARK: - Brick variables
    var bricksPerRow: Int?
    var numberOfRows: Int?
    let brickPadding = 5
    var bricks = [Int:BrickView]()
    var brickSize: CGSize {
        let width = (self.bounds.size.width / CGFloat(bricksPerRow!)) - CGFloat(2 * brickPadding )
        let height = (self.bounds.size.height / 3 / CGFloat(numberOfRows!)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Ball variables
    var balls = [BallView]()
    var ballSpeed: Float = 0.50
    var ballWidth: Float = 0.05
    var numberOfBalls: Int = 1
    
    // MARK: - Paddle variables
    private var panGesture: UIPanGestureRecognizer?
    var paddle: PaddleView? {
        didSet {
            if paddle != nil {
                self.panGesture = UIPanGestureRecognizer(target: paddle!, action: "move:")
                self.addGestureRecognizer(self.panGesture!)
            }
        }
    }
    var paddleWidth: Float = 0.40
    
    // MARK: - Theme
    var theme: BreakoutTheme!
    
    // MARK: - Loading
    func preloadGame() {
        self.animator.addBehavior(self.breakoutBehavior)
        self.breakoutBehavior.collisionDelegate = self
        
        var rect = self.bounds
        rect.size.height *= CGFloat(1 + 1.5 * ballWidth)
        self.breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: PathNames.BoxBarrier)
        
        let bottomBarrierOrigin = CGPoint(x: 0, y: rect.size.height)
        let bottomBarrierSize = CGSize(width: self.bounds.size.width, height: 1)
        self.breakoutBehavior.addBarrier(UIBezierPath(rect: CGRect(origin: bottomBarrierOrigin, size: bottomBarrierSize)), named: PathNames.BottomBarrier)
    }
    
    func pauseGame() {
        self.gameState = GameState.Paused
        for ball in self.balls {
            ball.lastVelocity = self.breakoutBehavior.stopBall(ball)
        }
    }
    
    func startGame() {
        self.gameState = GameState.Playing
        for ball in self.balls {
            if let velocity = ball.lastVelocity {
                self.breakoutBehavior.pushBall(ball, velocity: velocity)
            } else {
                self.breakoutBehavior.pushBall(ball, magnitude: self.ballSpeed)
            }
        }
    }
    
    func restartGame() {
        self.lives = BreakoutView.initialLives
        self.currentLevel = 0
        self.reloadGame()
        self.startGame()
    }
    
    func reloadGame() {
        self.removePaddle()
        self.removeBricks()
        self.removeBalls()
        self.loadGame()
    }
    
    func loadGame() {
        self.addBricks()
        self.addPaddle()
        self.addBalls()
        self.backgroundColor = self.theme.getBackgroundColor(forSize: self.bounds.size)
        self.gameState = .Loaded
    }
    
    func tryLoadNextLevel() -> Bool {
        self.currentLevel++
        if self.levels.count == self.currentLevel {
            return true;
        } else {
            self.reloadGame()
            return false;
        }
    }
    
    // MARK: - Bricks
    func addBricks() {
        var rows = split(self.levels[self.currentLevel]) {$0 == ":"}
        self.numberOfRows = rows.count
        for var rowNumber = 0; rowNumber < self.numberOfRows!; rowNumber++ {
            addRow(rowNumber, rowString: rows[rowNumber])
        }
    }
    
    func addRow(rowNumber: Int, rowString: String) {
        let brickInfo = split(rowString) {$0 == ","}
        self.bricksPerRow = brickInfo.count
        let size = self.brickSize
        
        for var brickNumber = 0; brickNumber < brickInfo.count; brickNumber++ {
            if brickInfo[brickNumber] != "0" {
                let x = (CGFloat(brickNumber) * (size.width + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
                let y = (CGFloat(rowNumber) * (size.height + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
                let origin = CGPoint(x: x, y: y)
                let brickHealth: Int = brickInfo[brickNumber].toInt()!
                let brick = BrickView(frame: CGRect(origin: origin, size: size), health: brickHealth)
                brick.backgroundColor = theme.getBrickColor(brickHealth, forSize: brick.bounds.size)
                
                let brickId = brickNumber + (brickInfo.count * rowNumber)
                bricks[brickId] = brick
                self.breakoutBehavior.addBarrier(UIBezierPath(roundedRect: brick.frame, cornerRadius: 0), named: brickId)
                self.breakoutBehavior.addBrick(brick)
            }
        }
    }
    
    func removeBricks() {
        for var i = 0; i < self.numberOfRows! * self.bricksPerRow!; i++ {
            if let brick = self.bricks[i] {
                brick.removeFromSuperview()
                self.breakoutBehavior.removeBrick(brick)
                self.breakoutBehavior.removeBarrier(named: i)
            }
        }
        
        if self.bricks.count > 0 {
            self.bricks.removeAll(keepCapacity: true)
        }
    }
    
    func removeBrickAtIndex(index: Int) {
        if let brick = bricks[index] {
            self.breakoutBehavior.removeBrick(brick)
            self.breakoutBehavior.removeBarrier(named: index)
        }
    }
    
    // MARK: - Balls
    func addBalls() {
        for var i = 0; i < numberOfBalls; i++
        {
            addBall(false)
        }
        
        if !balls.isEmpty {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: "push:"))
        }
    }
    
    func addBall(shouldPush: Bool) {
        var ball = BallView(gameFrame: bounds.size, maxWidth: CGFloat(ballWidth))
        ball.backgroundColor = theme?.getBallColor(forSize: ball.bounds.size)
        self.breakoutBehavior.addBall(ball)
        if shouldPush {
            self.breakoutBehavior.pushBall(ball, magnitude: self.ballSpeed)
        }
        self.balls.append(ball)
        
    }
    
    func removeBalls() {
        for ball in self.balls {
            ball.removeFromSuperview()
            self.breakoutBehavior.removeBall(ball)
        }
        self.balls.removeAll(keepCapacity: false)
        
    }
    
    func push(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            for ball in self.balls {
                //self.breakoutBehavior.pushBall(ball, magnitude: ballSpeed, angle: nil)
                self.breakoutBehavior.pushBall(ball, magnitude: self.ballSpeed)
            }
        }
    }
    
    // MARK: - Paddle
    func removePaddle() {
        self.paddle?.removeFromSuperview()
        self.removeGestureRecognizer(self.panGesture!)
        self.panGesture = nil
        self.paddle = nil
    }
    
    
    func addPaddle() {
        paddle = PaddleView(gameFrame: self.bounds.size, maxWidth: CGFloat(self.paddleWidth))
        paddle!.backgroundColor = theme?.getPaddleColor(forSize: paddle!.bounds.size)
        self.breakoutBehavior.addBarrier(UIBezierPath(rect: paddle!.frame), named: PathNames.PaddleBarrier)
        self.breakoutBehavior.addPaddle(paddle!)
        paddle!.setBreakoutBehavior(breakoutBehavior, withPathName: PathNames.PaddleBarrier)
    }
    
    func movePaddleBy(point: CGPoint) {
        self.paddle?.moveBy(point)
    }
    
    // MARK: - Collision
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if(identifier !== lastCollidedItem || lastCollidedItem === nil) {
            lastCollidedItem = identifier
            if let index = identifier as? Int {
                let brick = self.bricks[index]
                brick!.health = (brick!.health - 1)
                brick!.backgroundColor = theme?.getBrickColor(brick!.health, forSize: brick!.bounds.size)
                if let delegate = self.breakoutDelegate {
                    delegate.onBrickHit(brick!.health)
                }
                if brick?.health <= 0 {
                    self.removeBrickAtIndex(index)
                    self.bricks.removeValueForKey(index)
                    
                    if self.bricks.count == 0 && self.breakoutDelegate != nil {
                        self.breakoutDelegate!.onLevelCompleted()
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
                        self.breakoutDelegate?.onLivesChanged(0)
                    } else if self.lives > 0 {
                        self.addBall(true)
                        self.lives--
                    }
                }
            }
        }
    }
}
