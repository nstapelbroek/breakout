//
//  BezierPathsView.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

@IBDesignable
class BreakoutView: UIView {
    
    // MARK: - General variables
    private var bezierPaths = [String:UIBezierPath]()
    var breakoutBehavior: BreakoutBehavior?
    struct PathNames {
        static let BoxBarrier = "Box"
        static let BottomBarrier = "Bottom"
        static let PaddleBarrier = "Paddle"
    }
    
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
    
    // MARK: - Drawing
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for(_, path) in bezierPaths {
            path.stroke()
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
                let brick = BrickView(frame: CGRect(origin: origin, size: size), health: brickInfo[brickNumber].toInt()!)
                
                let brickId = brickNumber + (brickInfo.count * rowNumber)
                bricks[brickId] = brick
                breakoutBehavior!.addBarrier(UIBezierPath(roundedRect: brick.frame, cornerRadius: 0), named: brickId)
                self.breakoutBehavior!.addBrick(brick)
            }
        }
    }
    
    func removeBricks() {
        for var i = 0; i < self.numberOfRows! * self.bricksPerRow!; i++ {
            if let brick = self.bricks[i] {
                brick.removeFromSuperview()
                self.breakoutBehavior!.removeBrick(brick)
                self.breakoutBehavior!.removeBarrier(named: i)
            }
        }
        
        if self.bricks.count > 0 {
            self.bricks.removeAll(keepCapacity: true)
        }
    }
    
    func removeBrickAtIndex(index: Int) {
        if let brick = bricks[index] {
            breakoutBehavior!.removeBrick(brick)
            breakoutBehavior!.removeBarrier(named: index)
        }
    }
    
    // MARK: - Balls
    func addBalls() {
        for var i = 0; i < numberOfBalls; i++
        {
            addBall()
        }
        
        if !balls.isEmpty {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: "push:"))
        }
    }
    
    func addBall() {
        if self.breakoutBehavior != nil {
            var ball = BallView(gameFrame: bounds.size, maxWidth: CGFloat(ballWidth))
            ball.backgroundColor = UIColor.orangeColor()
            self.breakoutBehavior!.addBall(ball)
            self.breakoutBehavior!.pushBall(ball, magnitude: self.ballSpeed)
            self.balls.append(ball)
        }
    }
    
    func removeBalls() {
        if self.breakoutBehavior != nil {
            for ball in self.balls {
                ball.removeFromSuperview()
                self.breakoutBehavior!.removeBall(ball)
            }
            self.balls.removeAll(keepCapacity: false)
        }
    }
    
    func push(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            if self.breakoutBehavior != nil {
                for ball in self.balls {
                    self.breakoutBehavior!.pushBall(ball, magnitude: ballSpeed)
                }
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
        paddle?.backgroundColor = UIColor.blackColor()
        breakoutBehavior?.addBarrier(UIBezierPath(rect: paddle!.frame), named: PathNames.PaddleBarrier)
        self.breakoutBehavior?.addPaddle(paddle!)
        paddle!.setBreakoutBehavior(breakoutBehavior!, withPathName: PathNames.PaddleBarrier)
    }

}
