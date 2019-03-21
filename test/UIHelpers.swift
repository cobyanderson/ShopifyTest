//
//  UIHelpers.swift
//  test
//
//  Created by Samuel Coby Anderson on 3/21/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 0.30)
    }
}

public class CellAnimator {
    // placeholder for things to come -- only fades in for now
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
        let height = view.frame.size.height
        let width = view.frame.size.width
        view.frame.size.height = 0
        view.frame.size.width = 0
        UIView.animate(withDuration: 0.5) {
            view.layoutIfNeeded()
            view.frame.size.height = height
            view.frame.size.width = width
        }
    }
}

