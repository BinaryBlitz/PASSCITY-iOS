//
//  Coordinate.swift
//  PASSCITY
//
//  Created by Алексей on 29.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class Coordinates: Mappable {
  var lat: Float = 0
  var lng: Float = 0

  required init?(map: Map) {
  }

  init?(_ coordinate: CLLocationCoordinate2D?) {
    guard let coordinate = coordinate else { return nil }
    self.lat = Float(coordinate.latitude)
    self.lng = Float(coordinate.longitude)
  }

  func mapping(map: Map) {
    lat <- map["lat"]
    lng <- map["lng"]
  }
}
