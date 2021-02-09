//
//  Collection+Extension.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 09/02/21.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
