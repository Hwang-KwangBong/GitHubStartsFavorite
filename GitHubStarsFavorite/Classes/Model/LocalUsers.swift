//
//  LocalUsers.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/21.
//

import UIKit
import RxGRDB
import RxSwift
import GRDB

/// LocalUsers is responsible for high-level operations on the players database.
struct LocalUsers {
    
    private let database: DatabaseWriter
    
    init(database: DatabaseWriter) {
        self.database = database
    }
    
    func deleteAll() -> Single<Void> {
        database.rx.write(updates: _deleteAll)
    }
    
    func deleteOne(_ localUser: LocalUser) -> Single<Void> {
        database.rx.write(updates: { db in try self._deleteOne(db, localUser: localUser) })
    }
        
    /// An observable that tracks changes in the players
    func playersOrderedByName() -> Observable<[LocalUser]> {
        ValueObservation
            .tracking(LocalUser.all().orderByName().fetchAll)
            .rx.observe(in: database)
    }
    
    // MARK: - Implementation
    
    private func _deleteAll(_ db: Database) throws {
        try LocalUser.deleteAll(db)
    }
    
    private func _deleteOne(_ db: Database, localUser: LocalUser) throws {
        try localUser.delete(db)
    }
    
}
