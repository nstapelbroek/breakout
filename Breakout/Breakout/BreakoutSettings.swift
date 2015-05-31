//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Simon de Lang on 31-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class BreakoutSettings {
    private struct DefaultNames {
        static let PaddleWidth = "PaddleWidth"
        static let BallSpeed = "BallSpeed"
        static let NumberOfBalls = "NumberOfBalls"
        static let FirstLoad = "FirstLoad"
    }
    
    private static let defaultPaddleWidth = 0.20
    private static let defaultBallSpeed = 0.05
    private static let defaultNumberOfBalls = 1
    
    var paddleWidth: Double?
    var ballSpeed: Double?
    var numberOfBalls: Int?
    
    //Private init to force use of the load function.
    private init() {}
    
    static func load() -> BreakoutSettings {
        var settings = BreakoutSettings()
        var defaults = NSUserDefaults.standardUserDefaults()
        
        //Workaround because NSUserDefaults does not return Double? and Int? but Double and Int hence making it difficult to check if this is the first time the settings are loaded.
        let firstLoad = defaults.stringForKey(DefaultNames.FirstLoad)
        if firstLoad == nil {
            defaults.setValue("No", forKey: DefaultNames.FirstLoad)
            defaults = setDefaultSettings()
        }
        
        settings.paddleWidth = defaults.doubleForKey(DefaultNames.PaddleWidth)
        settings.ballSpeed = defaults.doubleForKey(DefaultNames.BallSpeed)
        settings.numberOfBalls = defaults.integerForKey(DefaultNames.NumberOfBalls)
        return settings;
    }
    
    static func setDefaultSettings() -> NSUserDefaults {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(defaultPaddleWidth, forKey: DefaultNames.PaddleWidth)
        defaults.setDouble(defaultBallSpeed, forKey: DefaultNames.BallSpeed)
        defaults.setInteger(defaultNumberOfBalls, forKey: DefaultNames.NumberOfBalls)
        return defaults
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(self.paddleWidth!, forKey: DefaultNames.PaddleWidth)
        defaults.setDouble(self.ballSpeed!, forKey: DefaultNames.BallSpeed)
        defaults.setInteger(self.numberOfBalls!, forKey: DefaultNames.NumberOfBalls)
    }
}