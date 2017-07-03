//
//  OpenLinkCell.swift
//  GithubSearch
//
//  Created by Filip Fajdetic on 03/07/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import UIKit

class OpenLinkCell: UITableViewCell {
    
    @IBOutlet weak var openLinkLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var openLinkLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        openLinkLabelHeight.constant = 48
    }
    
}
