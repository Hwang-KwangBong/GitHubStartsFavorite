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
              
              guard row == DataManager.shared.viewModelFavoriteAPI.userData.count - 1 else { return }
              guard let text = self.textFieldSearch.text else {
                  DataManager.shared.viewModelFavoriteAPI.clearList()
                  return
              }
              DataManager.shared.viewModelFavoriteAPI.page += 1
              self.requestUserList(quary: text)
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
                
                guard let text = self.textFieldSearch.text else {
                    DataManager.shared.viewModelFavoriteAPI.clearList()
                    return
                }
                
                if text.isEmpty == true {
                    DataManager.shared.viewModelFavoriteAPI.clearList()
                    return
                }
                self.requestUserList(quary: text)
                
            }).disposed(by: disposeBag)
        self.tableViewFavoriteAPI.refreshControl = refreshControl
        
    }
    
    func initSearch() {
        self.textFieldSearch.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { text in
                if text.isEmpty {
                    DataManager.shared.viewModelFavoriteAPI.clearList()
                    return
                }
                DataManager.shared.viewModelFavoriteAPI.clearList()
                self.requestUserList(quary: text)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func setBinding() {
        
        DataManager.shared.viewModelFavoriteAPI
            .modelGithubStarsFavoriteAPI
            .bind(to: tableViewFavoriteAPI.rx.items) { tableView, row, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "githubStarsFavoriteTableViewCellID")
                        as? GithubStarsFavoriteTableViewCell else { return UITableViewCell() }
                cell.labelName.text = element.name
                if let imageURL = URL(string: element.imageUrl) {
                    cell.imageViewProfile.kf.setImage(with: imageURL)
                }
                if DataManager.shared.viewModelFavoriteAPI.userData.isEmpty == false {
                    cell.isFavorite = DataManager.shared.viewModelFavoriteAPI.userData[row].isFavorite
                }
                cell.closure = { (isFavorite) in
                    DataManager.shared.viewModelFavoriteAPI.setFavoriteWithDB(index: row, isFavorite: isFavorite, user: element)                    
                }
                return cell
            }.disposed(by: disposeBag)
        
        DataManager.shared.viewModelFavoriteAPI
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                switch error {
                    case commonError.userMessage(let message):
                        self.showAlert(title: nil,message: message)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func requestUserList(quary:String) {
        DataManager.shared.viewModelFavoriteAPI
            .requestUserList(params: SearchUserParams(query: quary,
                                                      page: DataManager.shared.viewModelFavoriteAPI.page,
                                                      perPage: DataManager.shared.viewModelFavoriteAPI.perPage))
    }
    
}
