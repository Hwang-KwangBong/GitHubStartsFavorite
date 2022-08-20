//
//  GithubSearchUsersTarget.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import Moya

enum GithubSearchUsersTarget {
    case searchUser(SearchUserParams)
}

extension GithubSearchUsersTarget: BaseTargetType {
    var path: String {
        switch self {
            case .searchUser:
                return "/search/users"
        }
    }
    
    var method: Method {
        switch self {
            case .searchUser:
                return .get
        }
    }
    
    var task:Task {
        switch self {
            case .searchUser(let params):
                return .requestParameters(
                    parameters: params.toDictionary(),
                    encoding: URLEncoding.default
                )
        }
    }
}
