//
//  OtherInfoCell.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import UIKit

class OtherInfoCell: UITableViewCell {

    @IBOutlet weak var hasIssuesLabel: UILabel!
    @IBOutlet weak var defaultBranchLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomPadding.constant = 16
    }
    
}
