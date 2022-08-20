//
//  UIViewController+Extension.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: ((UIAlertController) -> Void)? = nil) {
        let alert = UIAlertController(title:title,message: message,preferredStyle: UIAlertController.Style.alert)
        //확인 버튼 만들기
        let ok = UIAlertAction(title: "확인", style: .default, handler: {
            action in
            if let callBack = completion {
                callBack(alert)
            }
        })
        alert.addAction(ok)
        present(alert,animated: true,completion: nil)
    }
    

}
