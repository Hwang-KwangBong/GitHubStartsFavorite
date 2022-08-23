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
    func initSearch() {
        self.textFieldSearch.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext:  { t in
                
                print("search capbong \(DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers)")
                let filterArray = DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers.filter({ $0.name.contains(t)})
                DataManager.shared.viewModelFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(filterArray)
            })
            .disposed(by: disposeBag)
        
    }
    
    func setBinding() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<Section>(configureCell: { (dataSource, tableView, indexPath, _) in
            let section = dataSource.sectionModels[indexPath.section]
            let localUser = section.items[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "githubStarsFavoriteTableViewCellID")
                    as? GithubStarsFavoriteTableViewCell else { return UITableViewCell() }
            cell.labelName.text = localUser.name
            if let firstChar = localUser.name.first {
                var preCategoryName = ""
                if indexPath.row != 0 {
                    preCategoryName = String(section.items[indexPath.row - 1].name.first!)
                }
                let stringFirst = String(firstChar)
                if stringFirst.isEmpty == false && preCategoryName == stringFirst {
                    cell.isCategory = true
                } else {
                    cell.isCategory = false
                    cell.labelCategory.text =  stringFirst
                }
            }
            guard let imageURL = URL(string: localUser.imageUrl) else { return cell}
            cell.imageViewProfile.kf.setImage(with: imageURL)
            cell.isFavorite = localUser.isFavorite
            cell.closure = { (isFavorite) in

                let localUser = LocalUser(id:localUser.id,name: localUser.name, imageUrl: localUser.imageUrl, isFavorite: isFavorite)
                DataManager.shared.setIsFavorite(localUser: localUser)
                Current.localUsers().deleteOne(localUser).subscribe({ result in
                    print("Delete \(result)")
                }).disposed(by: self.disposeBag)

                DataManager.shared.viewModelFavoriteLocal.localUsers.subscribe(onNext: { userdata in
                    guard let text = self.textFieldSearch.text else {
                        return
                    }
                    DataManager.shared.viewModelFavoriteLocal.originLocalUsers = userdata
                    DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers = userdata
                    let filterArray = DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers.filter({ $0.name.contains(text)})
                    DataManager.shared.viewModelFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(filterArray)
                    DataManager.shared.syncAPIUserAndLocalUser()
                }).disposed(by: self.disposeBag)
            }
            return cell
        })

        DataManager.shared.viewModelFavoriteLocal
            .modelGithubStarsFavoriteLocal
            .map { [Section(items: $0)] }
            .bind(to: tableViewFavoriteLocal.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
                    
    }
}

private struct Section {
    var items: [LocalUser]
}

extension Section: AnimatableSectionModelType {
    var identity: Int { return 1 }
    init(original: Section, items: [LocalUser]) {
        self.items = items
    }
}

extension LocalUser: IdentifiableType {
    var identity: Int64 { return id! }
}
