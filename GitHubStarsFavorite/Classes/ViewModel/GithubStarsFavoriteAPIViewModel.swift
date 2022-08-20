//
//  GithubStarsFavoriteAPIViewModel.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift

class GithubStarsFavoriteAPIViewModel: BaseViewModel {
    let modelGithubStarsFavoriteAPI:PublishSubject<[User]> = PublishSubject()
    
    // MARK: Network
    func requestUserList(params:SearchUserParams,_ isLoadingBar : Bool = true) {
        GithubSearchUsersAPI.getSearchUsersList(params: params) { response, error in
            guard let response = response else {
                let errorMessage = error?.localizedDescription ?? "잠시 후 다시 이용해 주세요."
                self.error.onNext(commonError.userMessage(errorMessage))
                return
            }
            
            print(response)
            self.modelGithubStarsFavoriteAPI.onNext(response.items)
            
        }
    }
}
