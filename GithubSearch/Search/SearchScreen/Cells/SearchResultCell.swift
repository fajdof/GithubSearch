//
//  SearchResultCell.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 01/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var issuesCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomPadding.constant = 16
    }

}
