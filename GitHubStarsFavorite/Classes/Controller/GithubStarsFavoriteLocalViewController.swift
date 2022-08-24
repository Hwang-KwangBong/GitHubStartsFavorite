//
//  GithubStarsFavoriteLocalViewController.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import RxDataSources

class GithubStarsFavoriteLocalViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableViewFavoriteLocal: UITableView!
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
        self.tableViewFavoriteLocal.register(
            UINib(nibName: "GithubStarsFavoriteTableViewCell",
                  bundle: Bundle(for: GithubStarsFavoriteTableViewCell.self)),
            forCellReuseIdentifier: "githubStarsFavoriteTableViewCellID")
        self.tableViewFavoriteLocal.keyboardDismissMode = .onDrag
    }
 
    func initSearch() {
        self.textFieldSearch.rx.text.orEmpty
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext:  { text in
                DataManager.shared.localSearchText = text
                print("search capbong \(DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers)")
                DataManager.shared.refreshFilteringLocalUsers()
                self.tableViewFavoriteLocal.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    func initRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { t in
                refreshControl.endRefreshing()
                self.tableViewFavoriteLocal.reloadData()
                
            }).disposed(by: disposeBag)
        self.tableViewFavoriteLocal.refreshControl = refreshControl
        
    }
    
    func setBinding() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<LocalSection>(configureCell: { (dataSource, tableView, indexPath, _) in
            let section = dataSource.sectionModels[indexPath.section]
            let localUser = section.items[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "githubStarsFavoriteTableViewCellID")
                    as? GithubStarsFavoriteTableViewCell else { return UITableViewCell() }
            self.setIndexingData(localUserName: localUser.name, row: indexPath.row, items: section.items, cell: cell)
            cell.labelName.text = localUser.name
            if let imageURL = URL(string: localUser.imageUrl) {
                cell.imageViewProfile.kf.setImage(with: imageURL)
            }
            cell.isFavorite = localUser.isFavorite
            cell.closure = { (isFavorite) in

                let localUser = LocalUser(id:localUser.id,name: localUser.name, imageUrl: localUser.imageUrl, isFavorite: isFavorite)
                DataManager.shared.setIsFavorite(localUser: localUser)
                Current.localUsers().deleteOne(localUser).subscribe({ result in
                    print("Delete \(result)")
                    DataManager.shared.refreshFilteringLocalUsers()
                    self.tableViewFavoriteLocal.reloadData()
                }).disposed(by: self.disposeBag)

            }
            return cell
        })

        DataManager.shared.viewModelFavoriteLocal
            .modelGithubStarsFavoriteLocal
            .map { [LocalSection(items: $0)] }
            .bind(to: tableViewFavoriteLocal.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        DataManager.shared.viewModelFavoriteLocal.localUsers.subscribe(onNext: { userdata in
            DataManager.shared.viewModelFavoriteLocal.originLocalUsers = userdata
            DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers = userdata
            DataManager.shared.refreshFilteringLocalUsers()
            DataManager.shared.syncAPIUser()
        }).disposed(by: self.disposeBag)
                    
    }
    
    func setIndexingData(localUserName:String, row:Int,items:[LocalUser],cell:GithubStarsFavoriteTableViewCell) {
        if let firstChar = localUserName.first {
            var preCategoryName = ""
            if row > 0 {
                preCategoryName = String(items[row - 1].name.first!)
            }
            
            if preCategoryName == String(firstChar) {
                cell.isCategory = true
            } else {
                cell.isCategory = false
                cell.labelCategory.text =  String(firstChar)
            }
        }
    }
}
