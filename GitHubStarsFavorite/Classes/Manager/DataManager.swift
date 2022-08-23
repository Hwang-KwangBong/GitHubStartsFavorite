//
//  DataManager.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/23.
//

import UIKit

class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    let viewModelFavoriteAPI:GithubStarsFavoriteAPIViewModel = GithubStarsFavoriteAPIViewModel()
    
    let viewModelFavoriteLocal:GithubStarsFavoriteLocalViewModel = GithubStarsFavoriteLocalViewModel()
    
//    var userData = [User]()
//    var originLocalUsers = [LocalUser]()
//    var localUsers: Observable<[LocalUser]>
//    var filteringLocalUsers = [LocalUser]()
//
//    let modelGithubStarsFavoriteAPI:PublishSubject<[User]> = PublishSubject()
//
//    public let error:PublishSubject<commonError> = PublishSubject()
//
//    init() {
//        let ordering = BehaviorRelay<Ordering>(value: .byName)
//        localUsers = ordering
//            .distinctUntilChanged()
//            .flatMapLatest { ordering -> Observable<[LocalUser]> in
//                switch ordering {
//                case .byName:
//                    return Current.localUsers().localUsersOrderedByName()
//                }
//            }
//    }
//
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
}
