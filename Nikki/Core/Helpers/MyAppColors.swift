//
//  MyAppColors.swift
//  Nikki
//
//  Created by Suhanee on 07/04/25.
//

import UIKit

struct MyAppColors {
    
    
    // MARK: - Helper: Convert hex string to UIColor
    private static func colorFromHex(_ hex: String) -> UIColor {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000ff) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    // MARK: - Color Palette
    
    /// Primary color from your design palette
    static let primary: UIColor = {
        return colorFromHex("#9FB3DF")
    }()
    
    /// Secondary color from your design palette
    static let secondary: UIColor = {
        return colorFromHex("#9EC6F3")
    }()
    
    /// Tertiary color from your design palette
    static let tertiary: UIColor = {
        return colorFromHex("#BDDEE4")
    }()
    
    /// Accent/Background color from your design palette
    static let accentBackground: UIColor = {
        return colorFromHex("#FFF1D5")
    }()
    
    /// Dynamic text color: Black in Light mode, White in Dark mode
    static let textColor: UIColor = {
        return UIColor { trait -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
    }()
}
