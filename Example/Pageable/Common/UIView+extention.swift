//
//  UIView+extention.swift
//  Pageable_Example
//
//  Created by Mrigank Gupta on 26/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
    static func nibName() -> String {
        return String(describing: self)
    }

    static func reusableIdetifier() -> String {
        return String(describing: self)
    }
}
