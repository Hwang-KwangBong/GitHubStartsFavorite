//
//  BaseTargetType.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import Moya

protocol BaseTargetType: TargetType {

}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var headers: [String : String]? {
        let header = ["Authorization": "token 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",
                      "Content-Type": "application/json; charset=utf-8",
                      "Accept": "application/vnd.github.v3+json"]
        return header
    }
    
    var sampleData: Data {
        return Data()
    }
}
