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
        return getThemeInstance(getThemeIndex(themeName))
    }
    
    static func getThemeInstance(themeIndex: Int) -> BreakoutTheme{
        switch themeIndex {
        case 1: return SavannaTheme()
        default: return DefaultBreaktoutTheme()
        }
    }
    
    static func getThemeIndex(themeName: String) -> Int {
        var themeIndex = themes.startIndex
        
        if let index = find(themes, themeName) {
            themeIndex = index
        }
        
        return themeIndex
    }
}