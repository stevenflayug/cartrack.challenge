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
    @IBOutlet weak var showHidePasswordButton: UIButton!
    @objc var countryPickerView = UIPickerView()
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupSqliteCredentials()
        viewModel.fetchCountries()
        setupNavigationBar()
        setupUI()
        setupActions()
        bindValues()
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetValues()
    }
    
    private func setupNavigationBar() {
           let titleLabel = UILabel()
           titleLabel.textColor = UIColor.white
           titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 19)
           titleLabel.text = "Log in"
           titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
           navigationItem.titleView = titleLabel
           
           navigationItem.setHidesBackButton(true, animated: true)
           navigationController?.navigationBar.isHidden = false
           navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           navigationController?.setStatusBar(backgroundColor: .userListLightBlue)
           navigationController?.navigationBar.backgroundColor = .userListLightBlue
           navigationController?.navigationBar.isTranslucent = true
           navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       }

    private func setupUI() {
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

        usernameLabel.font = UIFont(name: "Montserrat", size: 17.0)
        usernameLabel.font = UIFont(name: "Montserrat", size: 17.0)
        passwordLabel.font = UIFont(name: "Montserrat", size: 17.0)
        countryLabel.font = UIFont(name: "Montserrat", size: 17.0)
        usernameTextField.font = UIFont(name: "Montserrat", size: 17.0)
        passwordTextField.font = UIFont(name: "Montserrat", size: 17.0)
        passwordTextField.setRightPaddingPoints(35.0)
        countryTextField.font = UIFont(name: "Montserrat", size: 17.0)
        loginButton.titleLabel?.font =  UIFont(name: "Montserrat-SemiBold", size: 17.0)
        
        usernameLabel.text = "Username"
        passwordLabel.text = "Password"
        countryLabel.text = "Country"
        usernameTextField.placeholder = "Enter Username"
        passwordTextField.placeholder = "Enter Password"
        countryTextField.placeholder = "Select Country"
        loginButton.setTitle("SIGN IN", for: .normal)
        
        passwordTextField.isSecureTextEntry = true
        
        countryTextField.inputAccessoryView = toolBar
        // For disabling manual editing
        countryTextField.delegate = self
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryTextField.inputView = countryPickerView
    }
    
    private func bindValues() {
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
    
    private func setupObservables() {
        viewModel.loginSuccessful.asObservable().subscribe(onNext: { [unowned self] (successful) in
            if successful {
                HUD.flash(.success, onView: self.view, delay: 0.5, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
        
        viewModel.showPassword.asObservable().subscribe(onNext: { [unowned self] (show) in
            if show {
                self.passwordTextField.isSecureTextEntry = false
                self.showHidePasswordButton.setImage(UIImage(named: "hidePassword"), for: .normal)
            } else {
                self.passwordTextField.isSecureTextEntry = true
                self.showHidePasswordButton.setImage(UIImage(named: "showPassword"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    private func validateFields() -> Observable<Bool> {
        return Observable.combineLatest(viewModel.username, viewModel.password, viewModel.country)
        { (username, password, country) in
            return username.count > 0
                && password.count > 0
                && country.count > 0
        }
    }
    
    private func setupActions() {
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
        
        showHidePasswordButton.rx.tap.bind { [weak self] in
            if self?.viewModel.showPassword.value == true {
                self?.viewModel.showPassword.accept(false)
            } else {
                self?.viewModel.showPassword.accept(true)
            }
        }.disposed(by: disposeBag)
    }
    
    private func resetValues() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        countryTextField.text = ""
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
