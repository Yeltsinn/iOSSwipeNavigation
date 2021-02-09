//
//  ViewController.swift
//  iOSSwipeNavigationExamples
//
//  Created by Yeltsin Suares Lobato Gama on 05/02/21.
//

import UIKit
import iOSSwipeNavigation

class ViewController: UIViewController {
    
    var controllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        let swipeNavigationView = SwipeNavigationView()
        swipeNavigationView.frame = CGRect(x: view.frame.origin.x,
                                           y: view.frame.origin.y,
                                           width: view.frame.width,
                                           height: view.frame.height)
        view.addSubview(swipeNavigationView)
        
        let controllerRed = UIViewController()
        controllerRed.view.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        controllers.append(controllerRed)
        
        let controllerBlue = UIViewController()
        controllerBlue.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        controllers.append(controllerBlue)
        
        let controllerGreen = UIViewController()
        controllerGreen.view.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        controllers.append(controllerGreen)
        
        swipeNavigationView.dataSource = self
        swipeNavigationView.delegate = self
        swipeNavigationView.headerDelegate = self
        swipeNavigationView.headerDataSource = self
    }
}

extension ViewController: SNSwipeNavigationViewDataSource {
    
    func swipeNavigationViewNumberOfPages(_ swipeNavigationView: SwipeNavigationView) -> Int {
        return controllers.count
    }
    
    func swipeNavigationView(_ swipeNavigationView: SwipeNavigationView, controllerAtIndex index: Int) -> UIViewController {
        return controllers[index]
    }
}

extension ViewController: SNSwipeNavigationViewDelegate {
    
    func swipeNavigationView(pageSelected pageNumber: Int) {
        print("PAGE SELECTED: \(pageNumber)")
    }
}

extension ViewController: SwipeNavigationHeaderViewDelegate {
    
    func addTabViewIndicator() -> Bool {
        return true
    }
    
    func tabViewIndicatorHeightAsPercentOfHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat? {
        return 0.1
    }
    
    func tabViewIndicatorColor(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> UIColor {
        UIColor.brown
    }
    
    func swipeNavigationHeaderViewHeight(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat {
        return 100
    }
    
    func tabViewIndicatorWidthAsPercentOfHeaderViewWidth(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> CGFloat {
        return 0.5
    }
    
    func tabViewIndicatorAlignment(_ swipeNavigationHeaderView: SwipeNavigationHeaderView) -> SwipeNavigationHeaderView.TabViewAlignment {
        return .trailing
    }
}

extension ViewController: SwipeNavigationHeaderViewDataSource {
    
    func swipeNavigationHeaderView(_ swipeNavigationHeaderView: SwipeNavigationHeaderView, headerViewCellAt index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
