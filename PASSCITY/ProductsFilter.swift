//
//  ProgramsFilter.swift
//  PASSCITY
//
//  Created by Алексей on 10.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProductsFilter: Mappable, Equatable {
  var categories: [Int] = []
  var packages: Int = 1
  var services: Int = 1
  var expired: Int = 1
  var hotOffers: Int = 1

  init?(map: Map) { }

  init() { }

  mutating func mapping(map: Map) {
    packages <- map["packages"]
    categories <- map["categories"]
    services <- map["services"]
    expired <- map["expired"]
    hotOffers <- map["hot_offers"]
  }

  static func ==(lhs: ProductsFilter, rhs: ProductsFilter) -> Bool {
    return lhs.packages == rhs.packages &&
      lhs.categories == rhs.categories &&
      lhs.services == rhs.services &&
      lhs.expired == rhs.expired &&
      lhs.hotOffers == rhs.hotOffers
  }

}
