//
//  UIColor+Extensions.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let userListLightBlue = UIColor(hex: "#10b4c4")!
}

private extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString = String(hexString.suffix(hexString.count - 1)).lowercased()
        }
        
        guard let value = UInt(hexString, radix: 16) else { return nil }
        let red = CGFloat((value & 0xff0000) >> 16) / 255.0
        let green = CGFloat((value & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(value & 0x00ff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
