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
    let viewModelGithubStarsFavoriteLocal:GithubStarsFavoriteLocalViewModel = GithubStarsFavoriteLocalViewModel()
    
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
                
                print("search capbong \(self.viewModelGithubStarsFavoriteLocal.filteringLocalUsers)")
                let filterArray = self.viewModelGithubStarsFavoriteLocal.filteringLocalUsers.filter({ $0.name.contains(t)})
                self.viewModelGithubStarsFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(filterArray)
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
            guard let imageURL = URL(string: localUser.imageUrl) else { return cell}
            cell.imageViewProfile.kf.setImage(with: imageURL)
            cell.isFavorite = localUser.isFavorite
            cell.closure = { (isFavorite) in

                let localUser = LocalUser(id:localUser.id,name: localUser.name, imageUrl: localUser.imageUrl, isFavorite: isFavorite)
                if isFavorite == true {
                    Current.localUsers().insertOne(localUser).subscribe({ result in
                        print("Insert \(result)")
                    }).disposed(by: self.disposeBag)
                } else {
                    Current.localUsers().deleteOne(localUser).subscribe({ result in
                        print("Delete \(result)")
                    }).disposed(by: self.disposeBag)
                }
                self.viewModelGithubStarsFavoriteLocal.localUsers.subscribe(onNext: { userdata in
                    self.viewModelGithubStarsFavoriteLocal.filteringLocalUsers = userdata
                    self.viewModelGithubStarsFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(userdata)
                }).disposed(by: self.disposeBag)
            }
            return cell
        })

        viewModelGithubStarsFavoriteLocal
            .modelGithubStarsFavoriteLocal
            .map { [Section(items: $0)] }
            .bind(to: tableViewFavoriteLocal.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.viewModelGithubStarsFavoriteLocal.localUsers.subscribe(onNext: { userdata in
            self.viewModelGithubStarsFavoriteLocal.filteringLocalUsers = userdata
        }).disposed(by: self.disposeBag)
                    
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
