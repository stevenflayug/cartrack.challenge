//
//  UITextField+Extensions.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/19/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
