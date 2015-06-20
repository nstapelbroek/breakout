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
    
    override func getBallColor(forSize ballSize: CGSize?) -> UIColor {
        return UIColor.blackColor()
    }
    
    override func getPaddleColor(forSize paddleSize: CGSize?) -> UIColor {
        if let size = paddleSize {
            return UIColor.getUIColorNamed("savanna_paddle", forSize: size)
        } else {
            return super.getBackgroundColor(forSize: paddleSize)
        }
    }
    
    override func getBrickColor(brickHealth: Int, forSize brickSize: CGSize?) -> UIColor {
        if let size = brickSize {
            switch brickHealth {
            case 1: return UIColor.getUIColorNamed("savanna_block_1", forSize: size)
            case 2: return UIColor.getUIColorNamed("savanna_block_2", forSize: size)
            case 3: return UIColor.getUIColorNamed("savanna_block_3", forSize: size)
            case 4: return UIColor.getUIColorNamed("savanna_block_4", forSize: size)
            case 5: return UIColor.cyanColor()
            default: return UIColor.grayColor()
            }
        } else {
            return super.getBrickColor(brickHealth, forSize: brickSize)
        }
    }
    
    override func getBackgroundColor(forSize backgroundSize: CGSize?) -> UIColor {
        if let size = backgroundSize {
            return UIColor.getUIColorNamed("savanna_background", forSize: size)
        } else {
            return super.getBackgroundColor(forSize: backgroundSize)
        }
    }
}

private extension UIColor {
    static func getUIColorNamed(name: String, forSize imageSize: CGSize) -> UIColor {
        UIGraphicsBeginImageContext(imageSize)
        UIImage(named: name)!.drawInRect(CGRect(origin: CGPointZero, size: imageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image)
    }
}