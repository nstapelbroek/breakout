//
//  BreakoutThemeManager.swift
//  Breakout
//
//  Created by Mad Nico on 08/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class BreakoutThemeManager {
    static let themes = ["DefaultBreakoutTheme", "AnotherBreakoutTheme"]
    
    static func getThemeInstance(themeName: String) -> BreakoutTheme {
        switch themeName {
        case "AnotherBreakoutTheme": return AnotherBreaktoutTheme()
        default: break
        }
        return DefaultBreaktoutTheme()
    }
    
    static func getThemeInstance(themeIndex: Int) -> BreakoutTheme{
        switch themeIndex {
        case 1: return AnotherBreaktoutTheme()
        default: break
        }
        return DefaultBreaktoutTheme()
    }
    
    static func getThemeName(themeInstance: BreakoutTheme) -> String {
        if let theme = themeInstance as? AnotherBreaktoutTheme {
            return BreakoutThemeManager.themes[1]
        }
        return BreakoutThemeManager.themes[0]
    }  
    
    static func getThemeIndex(themeInstance: BreakoutTheme) -> Int {
        if let theme = themeInstance as? AnotherBreaktoutTheme {
            return 1
        }
        return 0
    }
}