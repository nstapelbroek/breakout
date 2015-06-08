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

    init(gameFrame: CGSize, maxWidth: CGFloat) {
        let width = gameFrame.width * maxWidth
        let size = CGSize(width: width, height: width)
        let x = (gameFrame.width - width) / 2
        let y = (gameFrame.height + width) / 2
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

}
