//
//  PaddleView.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class PaddleView: UIView {
    
    private var behavior: BreakoutBehavior?
    private var pathName: NSCopying?

    init(gameFrame: CGSize, maxWidth: CGFloat) {
        let width = gameFrame.width * maxWidth
        let height = gameFrame.height / 30
        let size = CGSize(width: width, height: height)
        let x = (gameFrame.width - width) / 2
        let y = gameFrame.height - (2 * height)
        let origin = CGPoint(x: x, y: y)
        
        super.init(frame: CGRect(origin: origin, size: size))
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func move(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Changed {
            let gestureLocation = gesture.locationInView(self)
            var newX = frame.origin.x + gestureLocation.x - (frame.width / 2)
            if newX > 0 && newX < (superview!.bounds.width - frame.width) {
                frame.origin = CGPoint(x: newX, y: frame.origin.y)
            }
            
            gesture.setTranslation(CGPointZero, inView: self)
            
            if behavior != nil && pathName != nil {
                behavior!.addBarrier(UIBezierPath(rect: frame), named: pathName!)
            }
        }
    }

    func setBreakoutBehavior(behavior: BreakoutBehavior, withPathName pathName: NSCopying) {
        self.behavior = behavior
        self.pathName = pathName
    }

}
