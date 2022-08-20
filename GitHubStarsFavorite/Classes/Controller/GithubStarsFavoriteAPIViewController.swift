//
//  GithubStarsFavoriteAPIViewController.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class GithubStarsFavoriteAPIViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModelGithubStarsFavoriteAPI:GithubStarsFavoriteAPIViewModel = GithubStarsFavoriteAPIViewModel()
    
    @IBOutlet weak var tableViewFavoriteAPI: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVariable()
        initTableView()
        setBinding()
    }

    
    func initVariable() {
        viewModelGithubStarsFavoriteAPI.requestUserList(params: SearchUserParams(query: "H", page: 1, perPage: 100))
    }
    
    func initTableView() {
        self.initRefreshControl()
        
        self.tableViewFavoriteAPI.register(
            UINib(nibName: "GithubStarsFavoriteTableViewCell",
                  bundle: Bundle(for: GithubStarsFavoriteTableViewCell.self)),
            forCellReuseIdentifier: "githubStarsFavoriteTableViewCellID")
        self.tableViewFavoriteAPI.keyboardDismissMode = .onDrag
    }
    
    func initRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { t in
                refreshControl.endRefreshing()
                self.viewModelGithubStarsFavoriteAPI
                    .requestUserList(params: SearchUserParams(query: "H", page: 1, perPage: 100))
            }).disposed(by: disposeBag)
        self.tableViewFavoriteAPI.refreshControl = refreshControl
        
    }
    
    func setBinding() {
        
        viewModelGithubStarsFavoriteAPI
            .modelGithubStarsFavoriteAPI
            .bind(to: tableViewFavoriteAPI.rx.items) { tableView, row, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "githubStarsFavoriteTableViewCellID")
                        as? GithubStarsFavoriteTableViewCell else { return UITableViewCell() }
                cell.labelName.text = element.name
                guard let imageURL = URL(string: element.imageUrl) else { return cell}
                cell.imageViewProfile.kf.setImage(with: imageURL)
                return cell
            }.disposed(by: disposeBag)
        
        viewModelGithubStarsFavoriteAPI
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                switch error {
                    case commonError.userMessage(let message):
                        self.showAlert(title: nil, message: message)
                }
                
            }).disposed(by: disposeBag)
    }
    
}
