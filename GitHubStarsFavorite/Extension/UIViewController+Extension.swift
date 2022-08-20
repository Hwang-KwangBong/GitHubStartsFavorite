//
//  UIViewController+Extension.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: ((UIAlertController) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let callBack = completion {
            callBack(alert)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
