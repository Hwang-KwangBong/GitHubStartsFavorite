//
//  User.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import Foundation

struct User {
    let name: String
    let imageUrl: String
    var isFavorite: Bool = false
}

// MARK: - Decodable
extension User: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case imageUrl =  "avatar_url"
    }
}

extension User: Hashable {

    static func == (_ lhs: User, _ rhs: User) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

