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
    let disposeBag = DisposeBag()
    var localUsers: Observable<[LocalUser]>
    var originLocalUsers = [LocalUser]()
    var filteringLocalUsers = [LocalUser]()
    let modelGithubStarsFavoriteLocal:PublishSubject<[LocalUser]> = PublishSubject()
    
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
    
}
