//
//  Intervals.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

class IntInterval: Mappable {
  var min: Int = 0
  var max: Int = 0

  required init?(map: Map) {
  }

  init() {

  }

  func mapping(map: Map) {
    min <- map["min"]
    max <- map["max"]
  }
}

struct DateInterval: Mappable, Equatable {
  var from: Date? = nil
  var to: Date? = nil

  init?(map: Map) {
  }

  init() { }

  mutating func mapping(map: Map) {
    from <- (map["from"], DateTimeTransform())
    to <- (map["to"], DateTimeTransform())
  }

  static func ==(lhs: DateInterval, rhs: DateInterval) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
  }
}
