//
//  Font.swift
//  WaterTracker
//
//  Created by Begüm Arıcı on 5.07.2025.
//

import UIKit

enum AppFont {
    
    static func black(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Black", size: size)!
    }

    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Bold", size: size)!
    }
    
    static func extraBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-ExtraBold", size: size)!
    }
    
    static func semiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-SemiBold", size: size)!
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Medium", size: size)!
    }

    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Regular", size: size)!
    }

    static func light(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Light", size: size)!
    }
    
    static func extraLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-ExtraLight", size: size)!
    }

    static func thin(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Jost-Thin", size: size)!
    }
}
