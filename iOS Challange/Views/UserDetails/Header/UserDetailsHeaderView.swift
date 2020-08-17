//
//  UserDetailsHeaderView.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/18/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit

class UserDetailsHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(title: String) {
        titleLabel.text = title
    }
}
