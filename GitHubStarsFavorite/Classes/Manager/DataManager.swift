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
    
    private init() {
        setBinding()
        self.viewModelFavoriteLocal.getLocaldata()
    }
    
    let viewModelFavoriteAPI:GithubStarsFavoriteAPIViewModel = GithubStarsFavoriteAPIViewModel()
    
    let viewModelFavoriteLocal:GithubStarsFavoriteLocalViewModel = GithubStarsFavoriteLocalViewModel()
    
    func setIsFavorite(localUser : LocalUser) {
        self.viewModelFavoriteAPI.userData.indices.filter{self.viewModelFavoriteAPI.userData[$0].id == localUser.id}.forEach{self.viewModelFavoriteAPI.userData[$0].isFavorite = localUser.isFavorite}
        self.viewModelFavoriteAPI.modelGithubStarsFavoriteAPI.onNext(viewModelFavoriteAPI.userData)
    }

    func syncAPIUserAndLocalUser() {
        for localUser in self.viewModelFavoriteLocal.originLocalUsers {
            self.viewModelFavoriteAPI.userData.indices.filter{self.viewModelFavoriteAPI.userData[$0].id == localUser.id}.forEach{self.viewModelFavoriteAPI.userData[$0].isFavorite = localUser.isFavorite}
        }
        self.viewModelFavoriteAPI.modelGithubStarsFavoriteAPI.onNext(self.viewModelFavoriteAPI.userData)
    }
    
    func setBinding() {
        self.viewModelFavoriteLocal.localUsers.subscribe(onNext: { userdata in
            self.viewModelFavoriteLocal.filteringLocalUsers = userdata
            self.viewModelFavoriteLocal.originLocalUsers = userdata
        }).disposed(by: self.disposeBag)
    }
}
