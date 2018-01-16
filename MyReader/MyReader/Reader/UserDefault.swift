//
//  UserDefault.swift
//  MyReader
//
//  Created by 黄穆斌 on 2018/1/16.
//  Copyright © 2018年 myron. All rights reserved.
//

import UIKit

class User {
    
    static var font_size: CGFloat {
        set { UserDefaults.standard.set(newValue, forKey: "User.font_size") }
        get {
            if let font = UserDefaults.standard.value(forKey: "User.font_size") as? CGFloat {
                return font
            } else {
                return 24
            }
        }
    }
    static var font: UIFont { return UIFont.systemFont(ofSize: font_size) }
    
    
    static var color_number: Int {
        set { UserDefaults.standard.set(newValue, forKey: "User.color_number") }
        get { return UserDefaults.standard.integer(forKey: "User.color_number") }
    }
    static var color_background: UIColor {
        switch color_number {
        case 0: return UIColor(255,255,255)
        case 1: return UIColor(199,237,204)
        case 2: return UIColor(180,180,180)
        case 3: return UIColor(30,30,30)
        default: return UIColor(255,255,255)
        }
    }
    static var color_text: UIColor {
        switch color_number {
        case 0: return UIColor(30,30,30)
        case 1: return UIColor(30,30,30)
        case 2: return UIColor(30,30,30)
        case 3: return UIColor(220,220,220)
        default: return UIColor(30,30,30)
        }
    }
}
