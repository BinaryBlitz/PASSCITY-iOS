//
//  Expo.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

enum PassCityFeedItemType: String {
  case expo = "expo"
  case event = "event"
}

class PassCityFeedItemShort: Mappable, Hashable {
  var id: Int = 0
  var title: String = ""
  var type: PassCityFeedItemType = .expo
  var category: Int = 0
  var reviews: ReviewsOverview = ReviewsOverview()
  var schedule: String = ""
  var description: String = ""
  var dates: String = ""
  var address: String = ""
  var favorites: Int = 0
  var coordinates: Coordinates? = nil
  var imgURL: URL? = nil

  // Expo::Short
  var distance: String = ""

  var categoryObject: Category? {
    let categories = ProfileService.instance.currentSettings?.categories
    return categories?.first { $0.id == category }
  }

  required init?(map: Map) {
    id <- map["id"]
    type <- (map["type"], EnumTransform<PassCityFeedItemType>())
    title <- map["attributes.title"]
    category <- map["attributes.category"]
    schedule <- map["attributes.schedule"]
    distance <- map["attributes.distance"]
    description <- map["attributes.description"]
    address <- map["attributes.address"]
    favorites <- map["attributes.favorites"]
    coordinates <- map["attributes.coordinates"]
    reviews <- map["reviews"]
    imgURL <- (map["links.img"], URLTransform())
    dates <- map["dates"]
  }

  init() {

  }

  func mapping(map: Map) {

  }

  var hashValue: Int {
    return id
  }

  static func ==(lhs: PassCityFeedItemShort, rhs: PassCityFeedItemShort) -> Bool {
    return lhs.id == rhs.id
  }

}
