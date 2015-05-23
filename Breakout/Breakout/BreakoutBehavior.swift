//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    var gravity = UIGravityBehavior()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        //lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        //Add action for collision
        return lazilyCreatedCollider
        }()
    
//    lazy var pusher: UIPushBehavior = {
//        let lazilyCreatedPusher = UIPushBehavior(items: nil, mode: UIPushBehaviorMode.Instantaneous)
//        lazilyCreatedPusher.magnitude = 0.25
//        lazilyCreatedPusher.angle = CGFloat(1.1 * M_PI)
//        return lazilyCreatedPusher
//        }()
    
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
        addChildBehavior(gravity)
        addChildBehavior(ballBehavior)
        
    }
    
    func addBall(ball: BallView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        //gravity.addItem(ball)
        ballBehavior.addItem(ball)
        //ballBehavior.addLinearVelocity(CGPoint(x: 100, y: 100) , forItem: ball)
    }
    
    func pushBall(ball: UIView) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        push.magnitude = 0.1
        
        push.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        push.action = { [weak push] in
            //Remove the push if it is no longer in use
            if !push!.active {
                self.removeChildBehavior(push!)
            }
        }
        addChildBehavior(push)
    }

    
    func addPaddle(paddle: PaddleView) {
        dynamicAnimator?.referenceView?.addSubview(paddle)
        //collider.addItem(paddle)
    }
    
    func addBrick(brick: BrickView) {
        dynamicAnimator?.referenceView?.addSubview(brick)
        //collider.addItem(brick)
    }
    
    func removeBrick(brick: BrickView) {
        //collider.removeItem(brick)
        brick.removeFromSuperview()
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }

}
