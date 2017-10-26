//
//  FeedItemsFilter.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct PassCityFeedItemFilter: Mappable, Equatable {
  var coordinates: Coordinates? = nil
  var locationName: String? = nil
  var categories: [Int] = []
  var now: Int = 0
  var dates: DateInterval? = nil
  var favorites: Int = 0
  var hotOffers: Int = 0

  init?(map: Map) { }

  init() { }

  mutating func mapping(map: Map) {
    coordinates <- map["coordinates"]
    categories <- map["categories"]
    now <- map["now"]
    dates <- map["dates"]
    favorites <- map["favorites"]
    hotOffers <- map["hot_offers"]
  }

  static func ==(lhs: PassCityFeedItemFilter, rhs: PassCityFeedItemFilter) -> Bool {
    return lhs.coordinates == rhs.coordinates &&
      lhs.categories == rhs.categories &&
      lhs.dates == rhs.dates &&
      lhs.now == rhs.now &&
      lhs.favorites == rhs.favorites &&
      lhs.hotOffers == rhs.hotOffers
  }

}
