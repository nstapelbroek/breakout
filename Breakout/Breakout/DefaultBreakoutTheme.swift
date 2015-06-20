//
//  DefaultUITheme.swift
//  Breakout
//
//  Created by Mad Nico on 04/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation
import UIKit

class DefaultBreaktoutTheme: BreakoutTheme {
    
    override class var Name: String { return "Default Theme" }
    
    override func getBallColor(forSize ballSize: CGSize?) -> UIColor {
        return UIColor.orangeColor()
    }
    
    override func getPaddleColor(forSize paddleSize: CGSize?) -> UIColor {
        return UIColor.blackColor()
    }
    
    override func getBrickColor(brickHealth: Int, forSize brickSize: CGSize?) -> UIColor {
        switch brickHealth {
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        case 5: return UIColor.greenColor()
        default: return UIColor.blackColor()
        }
    }
    
    override func getBackgroundColor(forSize backgroundSize: CGSize?) -> UIColor {
        return UIColor.whiteColor()
    }
}