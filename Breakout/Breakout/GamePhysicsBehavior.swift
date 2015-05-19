//
//  GamePhysicsBehavior.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class GamePhysicsBehavior: UIDynamicBehavior {
    var gravity = UIGravityBehavior()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
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
        lazilyCreatedBallBehavior.allowsRotation = true
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
        gravity.addItem(ball)
        ballBehavior.addItem(ball)
        ballBehavior.addLinearVelocity(CGPoint(x: 100, y: 100) , forItem: ball)
    }
    
    func addPaddle(paddle: PaddleView) {
        dynamicAnimator?.referenceView?.addSubview(paddle)
        collider.addItem(paddle)
    }
    
    func addBrick(brick: BrickView) {
        dynamicAnimator?.referenceView?.addSubview(brick)
        collider.addItem(brick)
    }
    
    func removeBrick(brick: BrickView) {
        collider.removeItem(brick)
        brick.removeFromSuperview()
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }

}
