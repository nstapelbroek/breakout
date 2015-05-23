//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    @IBOutlet weak var gameView: BezierPathsView!

    enum GameState: Int {
        case Initial = 0, Loaded, Playing, Paused, Finished
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(breakoutBehavior)
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
        breakoutBehavior.addBarrier(UIBezierPath(rect: rect), named: "Box")
    }
    
    var brickSize: CGSize {
        let width = (gameView.bounds.size.width / CGFloat(bricksPerRow)) - CGFloat(2 * brickPadding )
        let height = (gameView.bounds.size.height / 3 / CGFloat(numberOfRows)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }

    func addPaddle() {
        paddle = PaddleView(gameFrame: gameView.bounds.size, maxWidth: 0.20)
        paddle?.backgroundColor = UIColor.blackColor()
                    breakoutBehavior.addBarrier(UIBezierPath(rect: paddle!.frame), named: "Paddle")
        self.breakoutBehavior.addPaddle(paddle!)
    }
    
    func addBall() {
        ball = BallView(gameFrame: gameView.bounds.size, maxWidth: 0.05)
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
            
            breakoutBehavior.addBarrier(UIBezierPath(roundedRect: brick.frame, cornerRadius: 0), named: "\((brickNumber + (bricksPerRow * rowNumber)))")
            self.breakoutBehavior.addBrick(brick)
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

