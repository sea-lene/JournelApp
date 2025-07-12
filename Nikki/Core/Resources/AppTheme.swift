//
//  AppTheme.swift
//  Nikki
//
//  Created by Suhanee on 11/04/25.
//

import Foundation
import UIKit

enum AppTheme {
    static let primaryColor = UIColor(hex: "#9EC6F3")
    static let secondaryColor = UIColor.black
    static let tertiaryColor = UIColor(hex: "#BD DDE4") // subtle elements
    static let backgroundColor = UIColor(hex: "#FFF1D5")

    static func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.primaryColor
        appearance.titleTextAttributes = [
            .foregroundColor: AppTheme.secondaryColor,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]

        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppTheme.secondaryColor,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = AppTheme.secondaryColor
    }
}
