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
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        getLocationButton.setTitle("Show Location", for: .normal)
        getLocationButton.layer.cornerRadius = 10
    }
}
