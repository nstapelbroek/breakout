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
    
    func getBallColor(forSize ballSize: CGSize?) -> UIColor { return UIColor.blackColor() }
    
    func getPaddleColor(forSize paddleSize: CGSize?) -> UIColor { return UIColor.blackColor() }
    
    func getBrickColor(brickHealth: Int, forSize brickSize: CGSize?) -> UIColor { return UIColor.blackColor() }
    
    func getBackgroundColor(forSize backgroundSize: CGSize?) -> UIColor { return UIColor.whiteColor() }
    
}
