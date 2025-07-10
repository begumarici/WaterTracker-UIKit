//
//  NavigationAppearance.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 7.07.2025.
//

import UIKit

enum NavigationAppearance {
    static func configureGlobalAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(red: 82/255, green: 142/255, blue: 242/255, alpha: 1),
            .font: AppFont.black(34)
        ]

        let navBar = UINavigationBar.appearance()
        navBar.prefersLargeTitles = true
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
    }
}
