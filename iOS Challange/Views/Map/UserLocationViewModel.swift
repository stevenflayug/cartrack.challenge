//
//  UserLocationViewModel.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/18/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class UserLocationViewModel {
    let locationServicesEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let locationAuthorized: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let requestAuthorization: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationServicesEnabled.accept(true)
            checkLocationAuthorization()
        } else {
            errorMessage.accept("Please enable Location Access on Settings to show User Location")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationAuthorized.accept(true)
        case .denied:
            errorMessage.accept("Please enable Location Access on Settings to show User Location")
        case .notDetermined:
            requestAuthorization.accept(true)
        case .restricted:
            errorMessage.accept("Please enable Location Access on Settings to show User Location")
        case .authorizedAlways:
            locationAuthorized.accept(true)
        default:
            errorMessage.accept("Please enable Location Access on Settings to show User Location")
        }
    }
}

