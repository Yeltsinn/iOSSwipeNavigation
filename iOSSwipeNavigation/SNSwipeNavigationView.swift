//
//  SNSwipeNavigationView.swift
//  iOSSwipeNavigation
//
//  Created by Yeltsin Suares Lobato Gama on 05/02/21.
//

import UIKit

protocol SNCodableView: UIView {
    func setupComponents()
    func setupConstraints()
    func addSubviews()
    func buildView()
}

extension SNCodableView {
    func buildView() {
        setupComponents()
        addSubviews()
        setupConstraints()
    }
}

public protocol SNSwipeNavigationViewDataSource {
    func swipeNavigationViewNumberOfPages(_ swipeNavigationView: SwipeNavigationView) -> Int
    func swipeNavigationView(_ swipeNavigationView: SwipeNavigationView, controllerAtIndex index: Int) -> UIViewController
}

public protocol SNSwipeNavigationViewDelegate {
    func swipeNavigationView(pageSelected pageNumber: Int)
}

public class SwipeNavigationView: UIView, SNCodableView {
    
    public override func layoutSubviews() {
        guard !buildPaginationStarted else { return }
        buildPaginationStarted = true
        buildPagination()
        setupHeaderViewConstraints()
    }
    
    public var dataSource: SNSwipeNavigationViewDataSource?
    public var delegate: SNSwipeNavigationViewDelegate?
    public var headerDelegate: SwipeNavigationHeaderViewDelegate?
    public var headerDataSource: SwipeNavigationHeaderViewDataSource?
    
    /* View Components */
    var headerView: SwipeNavigationHeaderView
    var contentView: UIView
    var scrollView: UIScrollView
    
    /* Constraints Identifiers */
    let headerViewHeightConstraintId = "headerViewHeightConstraint"
    
    /* Auxiliar Variables */
    private var pageCount = 0
    private var buildPaginationStarted = false
    
    override init(frame: CGRect) {
        headerView = SwipeNavigationHeaderView()
        contentView = UIView()
        scrollView = UIScrollView()
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupComponents() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.withPagingEnabled(true).withDelegate(self).showsHorizontalScrollIndicator(false)
    }
    
    func setupConstraints() {
        
        /* MARK: HeaderView Constraints */
        let headerViewLeadingConstraint = NSLayoutConstraint(item: headerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        let headerViewTrailingConstraint = NSLayoutConstraint(item: headerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let headerViewTopConstraint = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        let headerViewHeightConstraint = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        headerViewHeightConstraint.identifier = headerViewHeightConstraintId
        
        /* MARK: ContentView Constraints */
        let contentViewLeadingConstraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        let contentViewTrailingConstraint = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let contentViewTopConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let contentViewBottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        /* MARK: ScrollView Constraints */
        let scrollViewLeadingConstraint = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        
        let scrollViewTrailingConstraint = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        
        let scrollViewTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        
        let scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([headerViewLeadingConstraint,
                                     headerViewTrailingConstraint,
                                     headerViewTopConstraint,
                                     headerViewHeightConstraint,
                                     contentViewLeadingConstraint,
                                     contentViewTrailingConstraint,
                                     contentViewTopConstraint,
                                     contentViewBottomConstraint,
                                     scrollViewLeadingConstraint,
                                     scrollViewTrailingConstraint,
                                     scrollViewTopConstraint,
                                     scrollViewBottomConstraint])
    }
    
    func addSubviews() {
        addSubview(headerView)
        addSubview(contentView)
        contentView.addSubview(scrollView)
    }
    
    private func buildPagination() {
        guard let numberOfPages = dataSource?.swipeNavigationViewNumberOfPages(self) else { return }
        for index in 0..<numberOfPages {
            guard let pageView = dataSource?.swipeNavigationView(self, controllerAtIndex: index) else { continue }
            addViewToPagination(pageView.view)
        }
    }
    
    /* MARK: Auxiliar Methods */
    func addViewToPagination(_ viewToAdd: UIView) {
        
        scrollView.addSubview(viewToAdd)
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        
        let viewToAddTopConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        
        let viewToAddBottomConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let viewToAddWidthConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0)
        
        self.layoutIfNeeded()
        
        let viewToAddLeadingDistanceConstraint = NSLayoutConstraint(item: viewToAdd, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: frame.width * CGFloat(pageCount))
        
        NSLayoutConstraint.activate([viewToAddTopConstraint,
                                     viewToAddBottomConstraint,
                                     viewToAddWidthConstraint,
                                     viewToAddLeadingDistanceConstraint])
        
        pageCount += 1
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(pageCount), height: 0)
    }
    
    /* MARK: HeaderView Setup*/
    func setupHeaderViewConstraints() {
        if let headerHeight = headerDelegate?.swipeNavigationHeaderViewHeight(headerView) {
            headerView.constraint(with: headerViewHeightConstraintId)?.constant = headerHeight
        }
        
        if let numberOfPages = dataSource?.swipeNavigationViewNumberOfPages(self) {
            for index in 0..<numberOfPages {
                guard let headerViewCell = headerDataSource?.swipeNavigationHeaderView(headerView, headerViewCellAt: index) else { continue }
                headerView.addHeaderViewCell(headerViewCell: headerViewCell, countOfItens: numberOfPages, index: index)
            }
            
            if headerDelegate?.addTabViewIndicator() == true {
                setupTabViewIndicator(numberOfPages: numberOfPages)
            }
        }
        layoutIfNeeded()
    }
    
    func setupTabViewIndicator(numberOfPages: Int) {
        
        headerView.setupTabViewIndicatorMainConstraints(countOfItens: numberOfPages, tabViewAlignment: headerDelegate?.tabViewIndicatorAlignment(headerView))
        headerView.setupTabViewAttributes(color: headerDelegate?.tabViewIndicatorColor(headerView))
        headerView.setupTabViewIndicatorWidhtAsPercentOfHeaderViewWidth(multiplier: headerDelegate?.tabViewIndicatorWidthAsPercentOfHeaderViewWidth(headerView))
        
        if let height = headerDelegate?.tabViewIndicatorHeight(headerView) {
            headerView.setupTabViewIndicatorHeight(height: height)
        } else if let multiplier = headerDelegate?.tabViewIndicatorHeightAsPercentOfHeaderViewHeight(headerView) {
            headerView.setupTabViewIndicatorHeightAsPercentOfHeaderViewHeight(multiplier: multiplier)
        }
    }
}

extension SwipeNavigationView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        headerView.constraint(with: headerView.tabViewIndicatorLeadingDistanceConstraintId)?.constant = scrollView.contentOffset.x/CGFloat(pageCount)
        self.layoutIfNeeded()
        
        let integerPart = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        let decimalPart = scrollView.contentOffset.x/scrollView.frame.size.width - CGFloat(integerPart)
        
        let currentPageIndex = decimalPart > 0.5 ? integerPart + 1 : integerPart
        
        guard floor(decimalPart) == decimalPart else { return }
        endEditing(true)
        headerView.deselectAllHeaderCells()
        headerView.selectHeaderCellAtIndex(currentPageIndex)
        delegate?.swipeNavigationView(pageSelected: currentPageIndex)
    }
}
