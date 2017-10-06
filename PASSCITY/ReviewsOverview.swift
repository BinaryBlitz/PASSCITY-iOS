//
//  ReviewsOverview.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReviewsOverview: Mappable {
  var qty: Int = 0

  // Expo::Short
  var rating: Float = 0

  // Event::Short
  var interesting: Float = 0
  var convenient: Float = 0

  init() { }

  init?(map: Map) {
  }

  mutating func mapping(map: Map) {
    qty <- map["qty"]
    rating <- map["rating"]

    interesting <- map["interesting"]
    convenient <- map["convenient"]

  }

}
