//
//  UserDetailsTableViewCell.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/17/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(title: String, value: String) {
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        valueLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.text = title
        valueLabel.text = value
    }
}
