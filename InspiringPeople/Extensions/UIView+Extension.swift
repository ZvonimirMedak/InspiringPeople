//
//  UIView+Extension.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import UIKit
public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
