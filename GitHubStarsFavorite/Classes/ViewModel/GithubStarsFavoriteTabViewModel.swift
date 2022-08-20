//
//  GithubStarsFavoriteTabViewModel.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import Tabman
import Pageboy

class GithubStarsFavoriteTabViewViewModel: NSObject {
    let tabTitle:[String] = [
        "API", "로컬"
    ]
    
    let githubStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    lazy var viewControllers:[UIViewController] = [
        githubStoryboard.instantiateViewController(withIdentifier: "githubStarsFavoriteAPIViewControllerID"),
        githubStoryboard.instantiateViewController(withIdentifier: "githubStarsFavoriteLocalViewControllerID"),
    ]
    
    func setButtonBar() -> TMBar {
        let bar = TMBarView.ButtonBar()
                
        // Customize bar properties including layout and other styling.
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.indicator.weight = .medium
        bar.indicator.cornerStyle = .eliptical
        bar.backgroundView.style = .clear
        
        // Set tint colors for the bar buttons and indicator.
        bar.buttons.customize {
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.tintColor = UIColor.black
            $0.selectedFont = UIFont.boldSystemFont(ofSize: 14)
            $0.selectedTintColor = UIColor.blue
        }
        bar.indicator.tintColor = UIColor.blue
        return bar
    }
    
}
