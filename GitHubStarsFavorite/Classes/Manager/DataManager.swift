//
//  DataManager.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/23.
//

import UIKit
import RxSwift

class DataManager {
    
    static let shared = DataManager()
    let disposeBag = DisposeBag()
        
    let viewModelFavoriteAPI:GithubStarsFavoriteAPIViewModel = GithubStarsFavoriteAPIViewModel()
    let viewModelFavoriteLocal:GithubStarsFavoriteLocalViewModel = GithubStarsFavoriteLocalViewModel()
    var localSearchText:String = String()
    
    private init() {
        setBinding()
    }
    
    func setIsFavorite(localUser : LocalUser) {
        self.syncFavorite(localUser: localUser)
        self.viewModelFavoriteAPI.modelGithubStarsFavoriteAPI.onNext(viewModelFavoriteAPI.userData)
    }
    
    func syncFavorite(localUser : LocalUser) {
        self.viewModelFavoriteAPI.userData.indices.filter{self.viewModelFavoriteAPI.userData[$0].id == localUser.id}.forEach{self.viewModelFavoriteAPI.userData[$0].isFavorite = localUser.isFavorite}
    }

    func syncAPIUserInsert() {
        syncLocaluser()
        syncAPIUser()
    }
    
    func syncAPIUserDelete() {
        syncAPIUser()
        syncLocaluser()
    }
    
    func syncAPIUser() {
        for localUser in self.viewModelFavoriteLocal.originLocalUsers {
            self.syncFavorite(localUser: localUser)
        }
        self.viewModelFavoriteAPI.modelGithubStarsFavoriteAPI.onNext(self.viewModelFavoriteAPI.userData)
    }
    
    func syncLocaluser() {
        let filterArray = DataManager.shared.viewModelFavoriteLocal.filteringLocalUsers.filter({ $0.name.contains(self.localSearchText)})
        DataManager.shared.viewModelFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(filterArray)
    }
    
    func setBinding() {
        self.viewModelFavoriteLocal.localUsers.subscribe(onNext: { userdata in
            self.viewModelFavoriteLocal.filteringLocalUsers = userdata
            self.viewModelFavoriteLocal.originLocalUsers = userdata
        }).disposed(by: self.disposeBag)
    }
    
    func refreshFilteringLocalUsers() {
        let filterArray = self.viewModelFavoriteLocal.filteringLocalUsers.filter({ $0.name.contains(self.localSearchText)})
        self.viewModelFavoriteLocal.modelGithubStarsFavoriteLocal.onNext(filterArray)
    }
}
