//
//  LocalUser.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/21.
//

import UIKit
import GRDB

struct LocalUser: Codable, Equatable {
    var id: Int64?
    var name: String
    let imageUrl: String
    var isFavorite: Bool = false
}

// Adopt FetchableRecord so that we can fetch players from the database.
// Implementation is automatically derived from Codable.
extension LocalUser: FetchableRecord { }

// Adopt MutablePersistable so that we can create/update/delete players in the
// database. Implementation is partially derived from Codable.
extension LocalUser: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// Define columns that we can use for our database requests.
// They are derived from the CodingKeys enum for extra safety.
extension LocalUser {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let imageUrl = Column(CodingKeys.imageUrl)
        static let isFavorite = Column(CodingKeys.isFavorite)
    }
}

// Define requests of players in a constrained extension to the
// DerivableRequest protocol.
extension DerivableRequest where RowDecoder == LocalUser {
    func orderByName() -> Self {
        return order(LocalUser.Columns.name)
    }
}
