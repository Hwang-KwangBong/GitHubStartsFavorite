//
//  GithubStarsFavoriteTableViewCell.swift
//  GitHubStarsFavorite
//
//  Created by kwangbong hwang on 2022/08/20.
//

import UIKit

class GithubStarsFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initVariable()
    }
    
    func initVariable() {
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.width / 2
    }
    
    @IBAction func favoriteAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
    
}
