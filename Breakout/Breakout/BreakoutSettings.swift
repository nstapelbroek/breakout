//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Simon de Lang on 31-05-15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class BreakoutSettings: Printable {
    
    var description: String {
        get {
            return "{ paddleWidth: \(self.paddleWidth!), ballSpeed: \(self.ballSpeed!), numberOfBalls: \(self.numberOfBalls!), ballWidth: \(self.ballWidth) }";
        }
    }
    
    private struct DefaultNames {
        static let PaddleWidth = "PaddleWidth"
        static let BallSpeed = "BallSpeed"
        static let NumberOfBalls = "NumberOfBalls"
        static let BallWidth = "BallWidth"
        static let FirstLoad = "FirstLoad"
    }
    
    private static let defaultPaddleWidth: Float = 0.20
    private static let defaultBallSpeed: Float = 0.05
    private static let defaultNumberOfBalls: Int = 1
    private static let defaultBallWidth: Float = 0.05
    
    var paddleWidth: Float?
    var ballSpeed: Float?
    var numberOfBalls: Int?
    var ballWidth: Float?
    
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
        
        settings.paddleWidth = defaults.floatForKey(DefaultNames.PaddleWidth)
        settings.ballSpeed = defaults.floatForKey(DefaultNames.BallSpeed)
        settings.numberOfBalls = defaults.integerForKey(DefaultNames.NumberOfBalls)
        settings.ballWidth = defaults.floatForKey(DefaultNames.BallWidth)
        return settings;
    }
    
    static func setDefaultSettings() -> NSUserDefaults {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(defaultPaddleWidth, forKey: DefaultNames.PaddleWidth)
        defaults.setFloat(defaultBallSpeed, forKey: DefaultNames.BallSpeed)
        defaults.setInteger(defaultNumberOfBalls, forKey: DefaultNames.NumberOfBalls)
        defaults.setFloat(defaultBallWidth, forKey: DefaultNames.BallWidth)
        return defaults
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(self.paddleWidth!, forKey: DefaultNames.PaddleWidth)
        defaults.setFloat(self.ballSpeed!, forKey: DefaultNames.BallSpeed)
        defaults.setInteger(self.numberOfBalls!, forKey: DefaultNames.NumberOfBalls)
        defaults.setFloat(self.ballWidth!, forKey: DefaultNames.BallWidth)
    }
}