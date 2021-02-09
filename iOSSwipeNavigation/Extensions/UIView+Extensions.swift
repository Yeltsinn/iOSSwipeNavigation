//
//  UIView+Extensions.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 09/02/21.
//

import UIKit

extension UIView {
    func constraint(with identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }
}
