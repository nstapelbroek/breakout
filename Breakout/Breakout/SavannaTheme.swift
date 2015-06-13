//
//  DefaultUITheme.swift
//  Breakout
//
//  Created by Mad Nico on 04/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation
import UIKit

class SavannaTheme: BreakoutTheme {
    
    static var Name = "Savanna Theme"
    
    func getBallColor() -> UIColor {
        return UIColor.greenColor()
    }
    
    func getPaddleColor() -> UIColor {
        return UIColor.purpleColor()
    }
    
    func getBrickColor(brickHealth: Int) -> UIColor {
        switch brickHealth {
        case 1: return UIColor(patternImage: UIImage(named: "savanna_block_1")!)
        case 2: return UIColor(patternImage: UIImage(named: "savanna_block_2")!)
        case 3: return UIColor(patternImage: UIImage(named: "savanna_block_3")!)
        case 4: return UIColor(patternImage: UIImage(named: "savanna_block_4")!)
        case 5: return UIColor.cyanColor()
        default: return UIColor.grayColor()
        }
    }
    
    func getBackgroundColor() -> UIColor {
        return UIColor(patternImage: UIImage(named: "savanna_background")!)
    }
}