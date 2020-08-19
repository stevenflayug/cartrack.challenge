//
//  UserLocationViewController.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/18/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import UIKit
import MapKit
import PKHUD
import RxSwift
import RxCocoa

class UserLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    private let annotation = MKPointAnnotation()
    
    private let viewModel = UserLocationViewModel()
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    
    var name: String!
    var userLocationLat: Double!
    var userLocationLong: Double!
    var locationMeterDistance = 100000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
        setupMapView()
        viewModel.checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    private func setupObservables() {
        viewModel.locationAuthorized.asObservable().subscribe(onNext: { [weak self] (authorized) in
            if authorized {
                self?.focusViewOnUserLocation()
            }
        }).disposed(by: disposeBag)
        
        viewModel.requestAuthorization.asObservable().subscribe(onNext: { [weak self] (shouldRequest) in
            if shouldRequest {
                self?.locationManager.requestWhenInUseAuthorization()
            }
        }).disposed(by: disposeBag)
        
        viewModel.locationServicesEnabled.asObservable().subscribe(onNext: { [weak self] (locationEnabled) in
            if locationEnabled {
                self?.setupLocationManager()
            }
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asObservable().subscribe(onNext: { (error) in
            if error != "" {
                HUD.flash(.labeledError(title: "Location Access Required", subtitle: error), delay: 2.0)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupMapView() {
        mapView.delegate = self
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        titleLabel.text = "\(name ?? "")'s Location"
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func focusViewOnUserLocation() {
        mapView.showsUserLocation = true
        let userLocation = CLLocationCoordinate2DMake(userLocationLat, userLocationLong)
        let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: CLLocationDistance(locationMeterDistance), longitudinalMeters: CLLocationDistance(locationMeterDistance))
        annotation.coordinate = userLocation
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
}

extension UserLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {

            focusViewOnUserLocation()
        }
    }
}
