//
//  Networkable.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import Moya

protocol Networkable {
    associatedtype Target: TargetType
    static func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    static func makeProvider() -> MoyaProvider<Target> {
        return MoyaProvider<Target>()
    }
}
