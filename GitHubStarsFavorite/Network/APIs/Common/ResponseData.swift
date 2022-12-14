//
//  ResponseData.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import Moya

struct ResponseData<Model: Codable> {
    
    static func processJSONResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
        switch result {
            case .success(let response):
                do {
                    // status code가 200...299인 경우만 success로 체크 (아니면 예외발생)
                    _ = try response.filterSuccessfulStatusCodes()
                    
                    let model = try JSONDecoder().decode(Model.self, from: response.data)
                    return .success(model)
                } catch {
                    return .failure(error)
                }
            case .failure(let error):
                return .failure(error)
        }
    }
    
}
