//
//  RootPageViewController.swift
//  FinalUniApp
//
//  Created by Christian Grinling on 06/06/2020.
//  Copyright © 2020 Christian Grinling. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    var pageList:[UITableViewController] = {
        
        let UniversityVC = UniversityPage()
        let UsersVC = UsersPage()
        let CourseVC = CoursePage()
        
        return [UniversityVC, UsersVC,  CourseVC]
        
        
    }()
    
    var currentIndex: Int {
    guard let vc = viewControllers?.first else { return 0 }
        return pageList.firstIndex(of: vc as! UITableViewController) ?? 0
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        self.view.backgroundColor = .clear
        
       let secondViewController = pageList[1]
        self.setViewControllers([secondViewController], direction: .forward, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        //corrects scrollview frame to allow for full-screen view controller pages
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pageList.firstIndex(of: viewController as! UITableViewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard pageList.count > previousIndex else {return nil}
        
        return pageList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pageList.firstIndex(of: viewController as! UITableViewController) else {return nil}
        
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
    
}




