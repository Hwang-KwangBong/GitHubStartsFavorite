//
//  GithubStarsFavoriteTabViewController.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Tabman
import Pageboy

class GithubStarsFavoriteTabViewController: TabmanViewController {
    
    let viewModelGithubStarsFavoriteTabView:GithubStarsFavoriteTabViewViewModel = GithubStarsFavoriteTabViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVariable()
    }
    
    func initVariable() {
        dataSource = self
        addBar(viewModelGithubStarsFavoriteTabView.setButtonBar(), dataSource: self, at: .top)
    }

}

extension GithubStarsFavoriteTabViewController:PageboyViewControllerDataSource {
    // MARK: PageboyViewControllerDataSource
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewModelGithubStarsFavoriteTabView.tabTitle.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        UIViewController()
//        viewControllers[index] // View controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil // Default page to display in the page view controller (nil equals default/first index).
    }
}

extension GithubStarsFavoriteTabViewController:TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: viewModelGithubStarsFavoriteTabView.tabTitle[index])
    }
}
