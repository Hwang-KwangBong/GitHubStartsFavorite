//
//  Users.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit

struct Users {

    var items: [User]
    var totalCount: Int?
    var incompleteResults: Bool
}

// MARK: - Decodable
extension Users: Codable {

    private enum CodingKeys: String, CodingKey {
        case items =  "items"
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}

