//
//  User.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import Foundation

struct User {

    let id : Int
    let name: String
    let url: String
    let imageUrl: String
}

// MARK: - Decodable
extension User: Codable {

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case url = "url"
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

