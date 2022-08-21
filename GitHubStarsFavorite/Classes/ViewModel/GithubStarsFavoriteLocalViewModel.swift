//
//  GithubStarsFavoriteLocalViewModel.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/21.
//

import UIKit
import RxCocoa
import RxSwift

class GithubStarsFavoriteLocalViewModel: BaseViewModel {
    var localUsers: Observable<[LocalUser]>
    
    private enum Ordering: Equatable {
        case byName
    }
    
    override init() {
        let ordering = BehaviorRelay<Ordering>(value: .byName)
        localUsers = ordering
            .distinctUntilChanged()
            .flatMapLatest { ordering -> Observable<[LocalUser]> in
                switch ordering {
                case .byName:
                    return Current.localUsers().localUsersOrderedByName()
                }
            }
    }
//    let data = Observable<[String]>.just(["cell1","cell2","cell3","cell1","cell2","cell3","cell1","cell2","cell3"])
//    let localUserData =  Current.localUsers().localUsersOrderedByName().asObservable()
//    let modelGithubStarsFavoriteLocal:PublishSubject<[LocalUser]> = PublishSubject()
//
//    func getLocalUserList() {
//        let localUserDB = Current.localUsers().localUsersOrderedByName()
//
//        modelGithubStarsFavoriteLocal.onNext(Observable<[LocalUser]>.of(localUserDB) )
//
//    }
}
