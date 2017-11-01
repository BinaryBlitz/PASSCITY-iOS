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

struct Coordinates: Mappable, Equatable {
  var lat: Float = 0
  var lng: Float = 0

  var mapScale: Int? = 0

  var name: String = ""

  var clLocationCoordinate2D: CLLocationCoordinate2D? {
    return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
  }

  init?(map: Map) {
  }

  init?(_ coordinate: CLLocationCoordinate2D?) {
    guard let coordinate = coordinate else { return nil }
    self.lat = Float(coordinate.latitude)
    self.lng = Float(coordinate.longitude)
  }

  static var current: Coordinates? {
    return Coordinates(LocationService.instance.currentLocation)
  }

  mutating func mapping(map: Map) {
    lat <- map["lat"]
    lng <- map["lng"]
    mapScale <- map["map_scale"]
  }

  static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
    return lhs.lat == rhs.lat && lhs.lng == rhs.lng && lhs.mapScale == rhs.mapScale
  }
}
