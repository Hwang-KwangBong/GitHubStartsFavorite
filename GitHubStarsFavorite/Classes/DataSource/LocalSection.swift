//
//  LocalSectionItem.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/24.
//

import UIKit
import RxDataSources

struct LocalSection {
    var items: [LocalUser]
}

extension LocalSection: AnimatableSectionModelType {
    var identity: Int { return 1 }
    init(original: LocalSection, items: [LocalUser]) {
        self.items = items
    }
}

extension LocalUser: IdentifiableType {
    var identity: Int64 { return id! }
}
