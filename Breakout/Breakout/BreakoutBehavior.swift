//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collider.collisionDelegate }
        set { collider.collisionDelegate = newValue }
    }
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //Add action for collision
        return lazilyCreatedCollider
        }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
        lazilyCreatedBallBehavior.allowsRotation = false
        lazilyCreatedBallBehavior.elasticity = 1.0
        lazilyCreatedBallBehavior.resistance = 0.0
        lazilyCreatedBallBehavior.friction = 0.0
        return lazilyCreatedBallBehavior
        }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    func addBall(ball: BallView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func pushBall(ball: UIView, magnitude: Float) {
        let angle = CGFloat(1.25 * M_PI + (0.5 * M_PI) * (Double(arc4random()) / Double(UINT32_MAX)))
        let velocityX = CGFloat(1000 * magnitude * Float(cos(angle)))
        let velocityY = CGFloat(1000 * magnitude * Float(sin(angle)))
        pushBall(ball, velocity: CGPoint(x: velocityX, y: velocityY))
    }
    
    func pushBall(ball: UIView, velocity: CGPoint) {
         ballBehavior.addLinearVelocity(velocity, forItem: ball)
    }
    
    func removeBall(ball: BallView) {
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func stopBall(ball: UIView) -> CGPoint {
        let velocity = ballBehavior.linearVelocityForItem(ball)
        ballBehavior.addLinearVelocity(CGPoint(x: -velocity.x, y: -velocity.y), forItem: ball)
        return velocity
    }

    func addPaddle(paddle: PaddleView) {
        dynamicAnimator?.referenceView?.addSubview(paddle)
    }
    
    func addBrick(brick: BrickView) {
        dynamicAnimator?.referenceView?.addSubview(brick)
    }
    
    func removeBrick(brick: BrickView) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionFlipFromBottom,
            animations: {
                let property = brick.getRandomProperty()
                switch property {
                    case "alpha": brick.alpha = 0.0
                    case "height": brick.bounds.size.height = 0
                    case "width": brick.bounds.size.width = 0
                    default : println("Something unexpected happend while animating the brick")
                }
            }, completion: { (success) -> Void in
                brick.removeFromSuperview()
            }
        )
    }
    
    func addBarrier(path: UIBezierPath, named name: NSCopying) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(named name: NSCopying) {
        collider.removeBoundaryWithIdentifier(name)
    }
}
