//
//  Optional+Extensions.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 09/02/21.
//

import Foundation

extension Optional {
    
    var notExists: Bool {
        return self ==  nil
    }
    
    var exists: Bool {
        return self != nil
    }
}

