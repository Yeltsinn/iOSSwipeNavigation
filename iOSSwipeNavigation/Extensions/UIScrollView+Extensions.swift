//
//  UIScrollView+Extensions.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 08/02/21.
//

import UIKit

extension UIScrollView {
    
    @discardableResult func withDelegate(_ delegate: UIScrollViewDelegate) -> UIScrollView {
        self.delegate = delegate
        return self
    }
    
    @discardableResult func withPagingEnabled(_ isPagingEnabled: Bool) -> UIScrollView {
        self.isPagingEnabled = isPagingEnabled
        return self
    }
    
    @discardableResult func showsHorizontalScrollIndicator(_ isToShow: Bool) -> UIScrollView {
        self.showsHorizontalScrollIndicator = isToShow
        return self
    }
    
    
}
