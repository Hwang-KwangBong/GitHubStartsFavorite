//
//  ViewController.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Tabman
import Pageboy

class GithubStarsFavoriteViewController: UIViewController  {

    let disposeBag = DisposeBag()
    let viewModelGithubStarsFavorite:GithubStarsFavoriteViewModel = GithubStarsFavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initVariable()
//        viewModelGithubStarsFavorite.requestUserList(params: SearchUserParams(query: "H", page: 1, perPage: 100))
    }
    


}

