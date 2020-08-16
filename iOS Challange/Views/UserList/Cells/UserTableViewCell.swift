//
//  UserTableViewCell.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 10
        usernameTitle.text = "Username"
        nameTitle.text = "Name"
    }
    
    func setupCell(username: String, name: String) {
        usernameLabel.text = username
        nameLabel.text = name
    }
}
