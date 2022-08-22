//
//  GithubStarsFavoriteTableViewCell.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit
import RxSwift
import RxCocoa

class GithubStarsFavoriteTableViewCell: UITableViewCell {
    var closure:((Bool) -> Void)? = nil
    var isFavorite:Bool = false {
        willSet(newValue) {
            buttonFavorite.isSelected = newValue
        }
    }
    
    var isCategory:Bool = false {
        willSet(newValue) {
            DispatchQueue.main.async {
                self.labelCategory.isHidden = newValue
            }
            
        }
    }
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var labelCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initVariable()
    }
    
    func initVariable() {
        self.buttonFavorite.isSelected = isFavorite
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.width / 2
    }
    
    @IBAction func favoriteAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if let closure = closure {
            closure(button.isSelected)
        }
        
    }
    
}
