//
//  UserLocationTableViewCell.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/18/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var getLocationButton: UIButton!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        getLocationButton.titleLabel?.font =  UIFont(name: "Montserrat", size: 17.0)
        getLocationButton.setTitle("Show Location", for: .normal)
        getLocationButton.layer.cornerRadius = 10
    }
}
