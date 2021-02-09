//
//  SwipeNavigationHeaderView.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 08/02/21.
//

import UIKit

public protocol SwipeNavigationHeaderViewDataSource {
    func swipeNavigationHeaderView(_ swipeNavigationHeaderView: SwipeNavigationHeaderView, headerViewCellAt index: Int) -> UIView
}

public protocol SwipeNavigationHeaderViewDelegate {
    func addTabViewIndicator() -> Bool
    func swipeNavigationHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat
    func tabViewIndicatorHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat?
    func tabViewIndicatorHeightAsPercentOfHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat?
    func tabViewIndicatorWidthAsPercentOfHeaderViewWidth(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat
    func tabViewIndicatorColor(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> UIColor
    func tabViewIndicatorAlignment(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> SwipeNavigationHeaderView.TabViewAlignment
}

public extension SwipeNavigationHeaderViewDelegate {
    func addTabViewIndicator() -> Bool { false }
    func swipeNavigationHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat { 0 }
    func tabViewIndicatorHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat? { nil }
    func tabViewIndicatorHeightAsPercentOfHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat? { nil }
    func tabViewIndicatorWidthAsPercentOfHeaderViewWidth(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat { 0 }
    func tabViewIndicatorColor(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> UIColor { .black }
    func tabViewIndicatorAlignment(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> SwipeNavigationHeaderView.TabViewAlignment { .leading }
}

public protocol SwipeNavigationHeaderViewCell {
    func setSelectedState()
    func setNonSelectedState()
}

public class SwipeNavigationHeaderView: UIView {
    
    public enum TabViewAlignment {
        case leading, trailing, center
        
        var constraintAttribute: NSLayoutConstraint.Attribute {
            switch self {
            case .leading: return .leading
            case .trailing: return .trailing
            case .center: return .centerX
            }
        }
    }
    
    /* Constants to default values */
    let defaultTabViewIndicatorColor: UIColor = .black
    
    /* View Components */
    var headerViewCells: [UIView]?
    var tabViewIndicatorContainer = UIView()
    var tabViewIndicator = UIView()
    
    let tabViewIndicatorLeadingDistanceConstraintId = "tabViewIndicatorLeadingDistanceConstraint"
    
    func setupTabViewAttributes(color: UIColor?) {
        tabViewIndicator.backgroundColor = color ?? defaultTabViewIndicatorColor
    }
    
    func setupTabViewIndicatorMainConstraints(countOfItens: Int, tabViewAlignment: TabViewAlignment?) {
        
        addSubview(tabViewIndicatorContainer)
        tabViewIndicatorContainer.addSubview(tabViewIndicator)
        tabViewIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        tabViewIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let tabViewIndicatorContainerWidthConstraint = NSLayoutConstraint(item: tabViewIndicatorContainer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1/CGFloat(countOfItens), constant: 0)
        
        let tabViewIndicatorContainerLeadingDistanceConstraint = NSLayoutConstraint(item: tabViewIndicatorContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        tabViewIndicatorContainerLeadingDistanceConstraint.identifier = tabViewIndicatorLeadingDistanceConstraintId
        
        let tabViewIndicatorContainerBottomConstraint = NSLayoutConstraint(item: tabViewIndicatorContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let tabViewIndicatorLeadingDistanceConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: .height, relatedBy: .equal, toItem: tabViewIndicatorContainer, attribute: .height, multiplier: 1, constant: 0)
        
        let tabViewIndicatorBottomConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: .bottom, relatedBy: .equal, toItem: tabViewIndicatorContainer, attribute: .bottom, multiplier: 1, constant: 0)
        
        let tabViewIndicatorAlignmentConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: tabViewAlignment?.constraintAttribute ?? .leading, relatedBy: .equal, toItem: tabViewIndicatorContainer, attribute: tabViewAlignment?.constraintAttribute ?? .leading, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([tabViewIndicatorContainerWidthConstraint,
                                     tabViewIndicatorContainerLeadingDistanceConstraint,
                                     tabViewIndicatorContainerBottomConstraint,
                                     tabViewIndicatorLeadingDistanceConstraint,
                                     tabViewIndicatorBottomConstraint,
                                     tabViewIndicatorAlignmentConstraint])
    }
    
    func setupTabViewIndicatorHeight(height: CGFloat) {
        
        let tabViewIndicatorHeightConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        
        NSLayoutConstraint.activate([tabViewIndicatorHeightConstraint])
    }
    
    func setupTabViewIndicatorHeightAsPercentOfHeaderViewHeight(multiplier: CGFloat) {
        
        let tabViewIndicatorHeightConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: multiplier, constant: 0)
        
        NSLayoutConstraint.activate([tabViewIndicatorHeightConstraint])
    }
    
    func setupTabViewIndicatorWidhtAsPercentOfHeaderViewWidth(multiplier: CGFloat?) {
        
        let tabViewIndicatorWidthConstraint = NSLayoutConstraint(item: tabViewIndicator, attribute: .width, relatedBy: .equal, toItem: tabViewIndicatorContainer, attribute: .width, multiplier: multiplier ?? 1, constant: 0)
        
        NSLayoutConstraint.activate([tabViewIndicatorWidthConstraint])
    }
    
    func addHeaderViewCell(headerViewCell: UIView, countOfItens: Int, index: Int) {
        
        addSubview(headerViewCell)
        headerViewCells?.append(headerViewCell)
        headerViewCell.translatesAutoresizingMaskIntoConstraints = false
        
        let headerViewCellConstraint = NSLayoutConstraint(item: headerViewCell, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        let headerViewCellBottomConstraint = NSLayoutConstraint(item: headerViewCell, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let headerViewCellWidthConstraint = NSLayoutConstraint(item: headerViewCell, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1/CGFloat(countOfItens), constant: 0)
        
        self.layoutIfNeeded()
        
        let headerViewCellLeadingDistanceConstraint = NSLayoutConstraint(item: headerViewCell, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: frame.width/CGFloat(countOfItens) * CGFloat(index))
        
        NSLayoutConstraint.activate([headerViewCellConstraint,
                                     headerViewCellBottomConstraint,
                                     headerViewCellWidthConstraint,
                                     headerViewCellLeadingDistanceConstraint])
    }
    
    func selectHeaderCellAtIndex(_ index: Int) {
        (headerViewCells?[safe: index] as? SwipeNavigationHeaderViewCell)?.setSelectedState()
    }
    
    func deselectAllHeaderCells() {
        headerViewCells?.forEach({ headerCell in (headerCell as? SwipeNavigationHeaderViewCell)?.setNonSelectedState() })
    }
}
