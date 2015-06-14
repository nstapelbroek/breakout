//
//  BreakoutThemeStruct.swift
//  Breakout
//
//  Created by Mad Nico on 04/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation
import UIKit

class BreakoutTheme {
    
    class var Name: String { return "Theme name" }
    
    func getBallColor() -> UIColor { return UIColor.blackColor() }
    
    func getPaddleColor() -> UIColor { return UIColor.blackColor() }
    
    func getBrickColor(brickHealth: Int) -> UIColor { return UIColor.blackColor() }
    
    func getBackgroundColor() -> UIColor { return UIColor.whiteColor() }
    
}
