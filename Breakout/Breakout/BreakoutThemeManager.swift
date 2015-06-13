//
//  BreakoutThemeManager.swift
//  Breakout
//
//  Created by Mad Nico on 08/06/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import Foundation

class BreakoutThemeManager {
    static let themes = [DefaultBreaktoutTheme.Name, SavannaTheme.Name]
    
    static func getThemeInstance(themeName: String) -> BreakoutTheme {
        switch themeName {
        case SavannaTheme.Name: return SavannaTheme()
        default: break
        }
        return DefaultBreaktoutTheme()
    }
    
    static func getThemeInstance(themeIndex: Int) -> BreakoutTheme{
        switch themeIndex {
        case 1: return SavannaTheme()
        default: break
        }
        return DefaultBreaktoutTheme()
    }
    
    static func getThemeName(themeInstance: BreakoutTheme) -> String {
        if let theme = themeInstance as? SavannaTheme {
            return BreakoutThemeManager.themes[1]
        }
        return BreakoutThemeManager.themes[0]
    }  
    
    static func getThemeIndex(themeInstance: BreakoutTheme) -> Int {
        if let theme = themeInstance as? SavannaTheme {
            return 1
        }
        return 0
    }
}