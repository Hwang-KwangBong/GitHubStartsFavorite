//
//  GithubSearchUsersAPI.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import Moya

struct GithubSearchUsersAPI: Networkable {
    typealias Target = GithubSearchUsersTarget
    
    static func getSearchUsersList(params: SearchUserParams,completion: @escaping(_ response:Users?,_ error:Error?) -> Void) {
        makeProvider().request(.searchUser(params)) { result in
            switch ResponseData<Users>.processJSONResponse(result) {
                case .success(let model):
                    return completion(model, nil)
                case .failure(let error):
                    return completion(nil, error)
            }
        }
    }
}
