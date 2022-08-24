//
//  BaseViewModel.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxCocoa
import RxSwift

public enum commonError {
    case userMessage(String)
}

class BaseViewModel {
    let disposeBag = DisposeBag()
    public let error:PublishSubject<commonError> = PublishSubject()
    
}

