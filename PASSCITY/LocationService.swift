//
//  LocationService.swift
//  PASSCITY
//
//  Created by Алексей on 29.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {

  static let instance = LocationService()
  private let locationManager = CLLocationManager()

  var currentLocation: CLLocationCoordinate2D? = nil

  private override init() {
    super.init()
    
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

    locationManager.delegate = self
  }

  func startMonitoring() {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }

  func stopMonitoring() {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }

}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedAlways else { return }
    manager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    currentLocation = location.coordinate
  }
}

