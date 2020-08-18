//
//  LoginViewModel.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/15/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    var countries: [String] = []
    
    let sqliteManager = SQLiteManager()
    let username: BehaviorRelay<String> = BehaviorRelay(value: "")
    let password: BehaviorRelay<String> = BehaviorRelay(value: "")
    let country: BehaviorRelay<String> = BehaviorRelay(value: "")
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    let loginSuccessful: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let loginDetailsComplete: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    func fetchCountries() {
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
    }
    
    func setupSqliteCredentials() {
        sqliteManager.addDefaultUser()
    }
    
    func login() {
        sqliteManager.login(username: username.value, password: password.value) { (error) in
            if error == nil {
                self.loginSuccessful.accept(true)
            } else {
                self.errorMessage.accept(error ?? "")
            }
        }
    }
}
