//
//  Wolrd.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/21.
//

import GRDB

/// Dependency Injection based on the "How to Control the World" article:
/// https://www.pointfree.co/blog/posts/21-how-to-control-the-world
struct World {
    /// Access to the players database
    func localUsers() -> LocalUsers { return LocalUsers(database: database()) }
    
    /// The database, private so that only high-level operations exposed by
    /// `players` are available to the rest of the application.
    private var database: () -> DatabaseWriter
    
    /// Creates a World with a database
    init(database: @escaping () -> DatabaseWriter) {
        self.database = database
    }
}

var Current = World(database: { fatalError("Database is uninitialized") })

