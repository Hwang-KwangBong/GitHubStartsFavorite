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
    var page = 1
    let perPage = 50
    var userData = [User]()
    
    let modelGithubStarsFavoriteAPI:PublishSubject<[User]> = PublishSubject()
        
    func clearList() {
        page = 1
        userData = [User]()
        self.modelGithubStarsFavoriteAPI.onNext(userData)
    }
    
    func setFavoriteWithDB(index:Int,isFavorite:Bool, user:User) {
        DataManager.shared.viewModelFavoriteAPI.userData[index].isFavorite = isFavorite
        let localUser = LocalUser(id:user.id,name: user.name, imageUrl: user.imageUrl, isFavorite: isFavorite)
        if isFavorite == true {
            Current.localUsers().insertOne(localUser).subscribe({ result in
                print("Insert \(result)")
                DataManager.shared.syncAPIUserInsert()
            }).disposed(by: self.disposeBag)
        } else {
            Current.localUsers().deleteOne(localUser).subscribe({ result in
                print("Delete \(result)")
                DataManager.shared.syncAPIUserDelete()
            }).disposed(by: self.disposeBag)
        }
    }
    
    // MARK: Network
    func requestUserList(params:SearchUserParams,_ isLoadingBar : Bool = true) {
        GithubSearchUsersAPI.getSearchUsersList(params: params) { response, error in
            guard let response = response else {
                let errorMessage = error?.localizedDescription ?? "잠시 후 다시 이용해 주세요."
                self.error.onNext(commonError.userMessage(errorMessage))
                return
            }
            
            print(response)
            self.userData.append(contentsOf: response.items)
            DataManager.shared.syncAPIUserInsert()
            self.modelGithubStarsFavoriteAPI.onNext(self.userData)
            
        }
    }
}
