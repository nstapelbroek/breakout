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
    
    override class var Name: String { return "Savanna Theme" }
    
    override func getBallColor() -> UIColor {
        return UIColor.greenColor()
    }
    
    override func getPaddleColor() -> UIColor {
        return UIColor.purpleColor()
    }
    
    override func getBrickColor(brickHealth: Int) -> UIColor {
        switch brickHealth {
        //TODO decide if we want to make UIColor's with images scaling or not
        case 1: return UIColor(patternImage: UIImage(named: "savanna_block_1")!)
        case 2: return UIColor(patternImage: UIImage(named: "savanna_block_2")!)
        case 3: return UIColor(patternImage: UIImage(named: "savanna_block_3")!)
        case 4: return UIColor(patternImage: UIImage(named: "savanna_block_4")!)
        case 5: return UIColor.cyanColor()
        default: return UIColor.grayColor()
        }
    }
    
    override func getBackgroundColor() -> UIColor {
        //TODO decide if we want to make UIColor's with images scaling or not
        return UIColor(patternImage: UIImage(named: "savanna_background")!)
    }
}