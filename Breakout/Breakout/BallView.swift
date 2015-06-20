//
//  BallView.swift
//  Breakout
//
//  Created by Simon de Lang on 19-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BallView: UIView {
    
    var lastVelocity: CGPoint?
    var fillColor: UIColor?

    init(gameFrame: CGSize, maxWidth: CGFloat, offset:Int = 0) {
        let width = gameFrame.width * maxWidth
        let size = CGSize(width: width, height: width)
        let x = (gameFrame.width - width) / 2 + CGFloat(-50 + (offset*50))
        let y = (gameFrame.height + width) / 2
        let origin = CGPoint(x: x, y: y)
        
        super.init(frame: CGRect(origin: origin, size: size))
        self.backgroundColor = UIColor.clearColor();
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        fillColor?.setFill()
        path.fill()
    }

}
