//
//  DefaultUITheme.swift
//  Breakout
//
//  Created by Mad Nico on 04/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation
import UIKit

class AnotherBreaktoutTheme: BreakoutTheme {
    
    var Name = "Another Theme"
    
    func getBallColor() -> UIColor {
        return UIColor.greenColor()
    }
    
    func getPaddleColor() -> UIColor {
        return UIColor.purpleColor()
    }
    
    func getBrickColor(brickHealth: Int) -> UIColor {
        switch brickHealth {
        case 1: return UIColor.yellowColor()
        case 2: return UIColor.redColor()
        case 3: return UIColor.blueColor()
        case 4: return UIColor.blackColor()
        case 5: return UIColor.cyanColor()
        default: return UIColor.grayColor()
        }
    }
}