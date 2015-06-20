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
    
    init(frame: CGRect, health: Int, background: UIColor) {
        super.init(frame: frame)
        self.size = frame.size
        self.origin = frame.origin
        self.backgroundColor = background
        self.health = health
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getRandomProperty() -> String {
        let array = ["alpha", "width", "height"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        return array[randomIndex]
    }

}