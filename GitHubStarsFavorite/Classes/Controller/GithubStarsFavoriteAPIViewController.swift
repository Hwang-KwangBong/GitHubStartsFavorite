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
    @IBOutlet weak var textFieldSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVariable()
    }

    
    func initVariable() {
        initTableView()
        initSearch()
        setBinding()
    }
    
    func initTableView() {
        self.initRefreshControl()
        self.initPagingnation()
        
        self.tableViewFavoriteAPI.register(
            UINib(nibName: "GithubStarsFavoriteTableViewCell",
                  bundle: Bundle(for: GithubStarsFavoriteTableViewCell.self)),
            forCellReuseIdentifier: "githubStarsFavoriteTableViewCellID")
        self.tableViewFavoriteAPI.keyboardDismissMode = .onDrag
    }
    
    func initPagingnation() {
        self.tableViewFavoriteAPI.rx.prefetchRows // IndexPath값들이 방출
          .compactMap(\.last?.row)
          .withUnretained(self)
          .bind { ss, row in
              
              guard row == ss.viewModelGithubStarsFavoriteAPI.userData.count - 1 else { return }
              guard let text = self.textFieldSearch.text else {
                  self.viewModelGithubStarsFavoriteAPI.clearList()
                  return
              }
              self.viewModelGithubStarsFavoriteAPI.page += 1
              ss.viewModelGithubStarsFavoriteAPI
                  .requestUserList(params: SearchUserParams(query: text,
                                                            page: self.viewModelGithubStarsFavoriteAPI.page,
                                                            perPage: self.viewModelGithubStarsFavoriteAPI.perPage))
          }
          .disposed(by: self.disposeBag)
    }
    
    func initRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { t in
                refreshControl.endRefreshing()
                self.viewModelGithubStarsFavoriteAPI.userData = [User]()
                self.viewModelGithubStarsFavoriteAPI.page = 1
                guard let text = self.textFieldSearch.text else {
                    self.viewModelGithubStarsFavoriteAPI.clearList()
                    return
                }
                
                if text.isEmpty == true {
                    self.viewModelGithubStarsFavoriteAPI.clearList()
                    return
                }
                
                self.viewModelGithubStarsFavoriteAPI
                    .requestUserList(params: SearchUserParams(query: text,
                                                              page: self.viewModelGithubStarsFavoriteAPI.page,
                                                              perPage: self.viewModelGithubStarsFavoriteAPI.perPage))
                
            }).disposed(by: disposeBag)
        self.tableViewFavoriteAPI.refreshControl = refreshControl
        
    }
    
    func initSearch() {
        self.textFieldSearch.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { t in
                if t.isEmpty {
                    self.viewModelGithubStarsFavoriteAPI.clearList()
                    return
                }
                self.viewModelGithubStarsFavoriteAPI.clearList()
                self.viewModelGithubStarsFavoriteAPI
                    .requestUserList(params: SearchUserParams(query: t,
                                                              page: self.viewModelGithubStarsFavoriteAPI.page,
                                                              perPage: self.viewModelGithubStarsFavoriteAPI.perPage))
            })
            .disposed(by: disposeBag)
        
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
                        self.showAlert(title: nil,message: message)
                }
                
            }).disposed(by: disposeBag)
    }
    
}
