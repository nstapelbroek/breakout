//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var gameView: BezierPathsView!

    enum GameState: Int {
        case Initial = 0, Loaded, Playing, Paused, Finished
    }

    struct PathNames {
        static let BoxBarrier = "Box"
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
    var ball: BallView?
    var bricks = [Int:BrickView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.collisionDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if gameState == .Initial {
            addBricks()
            addPaddle()
            addBall()
            gameState = .Loaded
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var rect = gameView.bounds
        //Double the height to make the ball disappear when it hits the bottom of the screen
        //rect.size.height *= 2
        breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: PathNames.BoxBarrier)
    }
    
    var brickSize: CGSize {
        let width = (gameView.bounds.size.width / CGFloat(bricksPerRow)) - CGFloat(2 * brickPadding )
        let height = (gameView.bounds.size.height / 3 / CGFloat(numberOfRows)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }

    func addPaddle() {
        let width = gameView.bounds.size.width / 5
        let height = gameView.bounds.size.height / 30
        let size = CGSize(width: width, height: height)
        let x = (gameView.bounds.size.width - width) / 2
        let y = gameView.bounds.size.height - (2 * height)
        let origin = CGPoint(x: x, y: y)

        paddle = PaddleView(frame: CGRect(origin: origin, size: size))
        paddle?.backgroundColor = UIColor.blackColor()
                    breakoutBehavior.addBarrier(UIBezierPath(rect: paddle!.frame), named: PathNames.PaddleBarrier)
        self.breakoutBehavior.addPaddle(paddle!)
    }
    
    func addBall() {
        let width = gameView.bounds.size.width / 20
        let size = CGSize(width: width, height: width)
        let x = (gameView.bounds.size.width - width) / 2
        let y = (gameView.bounds.size.height + width) / 2
        let origin = CGPoint(x: x, y: y)
        
        ball = BallView(frame: CGRect(origin: origin, size: size))
        ball?.backgroundColor = UIColor.orangeColor()
        self.breakoutBehavior.addBall(ball!)
        self.breakoutBehavior.pushBall(ball!)
    }
    
    func addBricks() {
        for var rowNumber = 0; rowNumber < numberOfRows; rowNumber++ {
            addRow(rowNumber)
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
        if let index = identifier as? Int {
            removeBrickAtIndex(index)
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

