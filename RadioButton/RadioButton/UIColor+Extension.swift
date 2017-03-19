//
//  UIColor+Extension.swift
//  RadioButton
//
//  Created by Siyang Liu on 17/3/18.
//  Copyright © 2017年 Siyang Liu. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class var random: UIColor {
        get {
            let red = arc4random() % 255
            let green = arc4random() % 255
            let blue = arc4random() % 255
            return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        }
    }
}
