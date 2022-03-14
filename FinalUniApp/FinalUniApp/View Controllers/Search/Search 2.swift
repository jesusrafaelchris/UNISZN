//
//  Search.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 16/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class Search: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

 var pageList:[UIViewController] = {
        
        let UniversityVC = UniversityPage()
        let UsersVC = UsersPage()
        let CourseVC = CoursePage()
        
        return [UniversityVC, UsersVC,  CourseVC]
        
    }()

        var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
            return pageList.firstIndex(of: vc ) ?? 0
      }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "Search"
            self.view.backgroundColor = .white
            dataSource = self
            delegate = self
            let secondViewController = pageList[1]
            self.setViewControllers([secondViewController], direction: .forward, animated: true, completion: nil)
        }

        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let vcIndex = pageList.firstIndex(of: viewController) else {return nil}
            
            let previousIndex = vcIndex - 1
            
            guard previousIndex >= 0 else {return nil}
            
            guard pageList.count > previousIndex else {return nil}
            
            return pageList[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let vcIndex = pageList.firstIndex(of: viewController) else {return nil}
            
            let nextIndex = vcIndex + 1
            
            guard pageList.count != nextIndex else {return nil}
            
            guard pageList.count > nextIndex else {return nil}
            
            return pageList[nextIndex]
        }
        
        private func setupPageControl() {
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = .gray
            appearance.currentPageIndicatorTintColor = .black
        }
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int {
            setupPageControl()
            return pageList.count
        }

        func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            return currentIndex
        }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
