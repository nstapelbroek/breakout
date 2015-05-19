//
//  PaddleView.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class PaddleView: UIView {

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
        }
    }

}
