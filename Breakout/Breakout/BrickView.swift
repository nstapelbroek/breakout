//
//  DropView.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BrickView: UIView {
    
    private var size: CGSize?
    
    private var origin: CGPoint?
    var health: Int = 1
    
    init(frame: CGRect, health: Int) {
        super.init(frame: frame)
        self.size = frame.size
        self.origin = frame.origin
        self.setNewHealth(health)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setNewHealth(newHealth: Int) {
        self.health = newHealth
        var color = UIColor.blackColor()
        
        switch self.health {
        case 1: color = UIColor.blueColor()
        case 2: color = UIColor.orangeColor()
        case 3: color = UIColor.redColor()
        case 4: color = UIColor.purpleColor()
        case 5: color = UIColor.greenColor()
        default: break
        }

        self.backgroundColor = color
    }
    
    func getRandomProperty() -> String {
        let array = ["alpha", "width", "height"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }

}