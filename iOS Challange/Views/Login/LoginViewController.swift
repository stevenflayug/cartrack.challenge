//
//  LoginViewController.swift
//  Cartrack Challenge
//
//  Created by Steven Layug on 8/15/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @objc var countryPickerView = UIPickerView()
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchCountries()
        setupUI()
        setupActions()
    }

    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        loginButton.layer.cornerRadius = 10
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneTapped))
        let padding = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([padding, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        countryTextField.inputAccessoryView = toolBar
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryTextField.inputView = countryPickerView
    }
    
    // Actions
    func setupActions() {
        loginButton.rx.tap.bind { [unowned self] in
            HUD.show(.success, onView: self.view)
        }.disposed(by: disposeBag)
    }
    
    @objc func doneTapped() {
        countryTextField.resignFirstResponder()
    }
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = viewModel.countries[row]
    }
}
