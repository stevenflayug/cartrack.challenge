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
import SQLite3

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @objc var countryPickerView = UIPickerView()
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupSqliteCredentials()
        viewModel.fetchCountries()
        setupUI()
        setupActions()
        bindValues()
        setupObservables()
    }

    func setupUI() {
        //FOR TESTING
        usernameTextField.text = "stevenflayug"
        passwordTextField.text = "cartrack"
        countryTextField.text = "Philippines"
        
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

        usernameLabel.text = "Username"
        passwordLabel.text = "Password"
        countryLabel.text = "Country"
        usernameTextField.placeholder = "Enter Username"
        passwordTextField.placeholder = "Enter Password"
        countryTextField.placeholder = "Select Country"
        
        passwordTextField.isSecureTextEntry = true
        
        countryTextField.inputAccessoryView = toolBar
        // For disabling manual editing
        countryTextField.delegate = self
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryTextField.inputView = countryPickerView
    }
    
    func bindValues() {
        //Bind username and password values
        usernameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        countryTextField.rx.text
            .orEmpty
            .bind(to: viewModel.country)
            .disposed(by: disposeBag)
        
        validateFields().bind(to: viewModel.loginDetailsComplete).disposed(by: disposeBag)
    }
    
    func setupObservables() {
        viewModel.loginSuccessful.asObservable().subscribe(onNext: { [unowned self] (successful) in
            if successful {
                HUD.flash(.success, onView: self.view, delay: 1.0, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let userListVC = UserListTableViewController()
                        userListVC.modalPresentationCapturesStatusBarAppearance = true
                        self.navigationController?.pushViewController(userListVC, animated: true)
                    }
                }

        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asObservable().subscribe(onNext: { (error) in
            if error != "" {
                HUD.flash(.labeledError(title: "Login Error", subtitle: error), onView: self.view, delay: 1, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func validateFields() -> Observable<Bool> {
        return Observable.combineLatest(viewModel.username, viewModel.password, viewModel.country)
        { (username, password, country) in
            return username.count > 0
                && password.count > 0
                && country.count > 0
        }
    }
    
    // Actions
    func setupActions() {
        loginButton.rx.tap.bind { [unowned self] in
            if self.viewModel.loginDetailsComplete.value {
                HUD.show(.progress, onView: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.viewModel.login()
                }
            } else {
                HUD.flash(.labeledError(title: "Login Error", subtitle: "Please fill all fields to login"), onView: self.view, delay: 1, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func doneTapped() {
        if countryPickerView.selectedRow(inComponent: 0) == 0 {
            countryTextField.text = viewModel.countries[0]
        }
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

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
