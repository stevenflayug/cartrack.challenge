//
//  LoginViewModel.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/15/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation

class LoginViewModel {
    var countries: [String] = []

    func fetchCountries() {
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        print(countries)
    }
}
