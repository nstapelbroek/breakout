//
//  BreakoutThemeStruct.swift
//  Breakout
//
//  Created by Mad Nico on 04/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation
import UIKit

protocol BreakoutTheme {
    
    static var Name: String { get }
    
    func getBallColor() -> UIColor
    
    func getPaddleColor() -> UIColor
    
    func getBrickColor(brickHealth: Int) -> UIColor
    
    func getBackgroundColor() -> UIColor
    
}
