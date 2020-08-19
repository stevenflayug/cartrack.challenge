//
//  NameTableViewCell.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/17/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(name: String) {
        valueLabel.font = UIFont(name: "Montserrat-SemiBold", size: 19)
        valueLabel.text = name
    }
}
