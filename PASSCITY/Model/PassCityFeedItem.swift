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

class PassCityFeedItem: Mappable, Hashable {
  var id: Int = 0
  var title: String = ""
  var type: PassCityFeedItemType = .expo
  var category: Int = 0
  var reviews: ReviewsOverview = ReviewsOverview()
  var schedule: String = ""
  var description: String = ""
  var fullDecription: String = ""
  var dates: String = ""
  var address: String = ""
  var favorites: Int = 0
  var coordinates: Coordinates? = nil
  var imgURL: URL? = nil

  var imgs: [URL] = []

  // Expo::Short
  var distance: String = ""

  var categoryObject: Category? {
    let categories = ProfileService.instance.currentSettings?.allCategories
    return categories?.first { $0.id == category }
  }

  // Full
  var reviewsState: ReviewsState? = nil
  var shortSchedule: String = ""
  var fullSchedule: ScheduleState? = nil
  var addressFull: Address? = nil
  var services: [Service] = []
  var contacts: Contacts? = nil
  var events: [PassCityFeedItem] = []
  var expos: [PassCityFeedItem] = []
  var instruction: [String]  = []


  required init?(map: Map) {  }

  init() {

  }


  func mapping(map: Map) {
    id <- (map["id"], IdTransform())
    type <- (map["type"], EnumTransform<PassCityFeedItemType>())
    title <- map["attributes.title"]
    category <- (map["attributes.category"], IdTransform())
    schedule <- map["attributes.schedule"]
    distance <- map["attributes.distance"]
    description <- map["attributes.description"]
    address <- map["attributes.address"]
    favorites <- map["attributes.favorites"]
    coordinates <- map["attributes.coordinates"]
    reviews <- map["attributes.reviews"]
    imgURL <- (map["links.img"], URLTransform())
    imgs <- (map["links.img"], URLTransform())
    dates <- map["attributes.dates"]
    fullDecription <- map["attributes.full_decription"]
    addressFull <- map["attributes.address"]
    contacts <- map["attributes.contacts"]
    reviewsState <- map["attributes.reviews"]
    events <- map["relationships.events.data"]
    expos <- map["relationships.expos.data"]
    fullSchedule <- map["attributes.schedule"]
    services <- map["attributes.service"]
    instruction <- map["attributes.instruction"]

  }
  var hashValue: Int {
    return id
  }

  static func ==(lhs: PassCityFeedItem, rhs: PassCityFeedItem) -> Bool {
    return lhs.id == rhs.id
  }

}

struct Service: Mappable {
  var id: String = ""
  var title: String = ""
  var price: String = ""


  init(map: Map) {  }

  mutating func mapping(map: Map) {
    id <- map["id"]
    title <- map["title"]
    price <- map["price"]
  }
}

struct ScheduleState: Mappable {
  var short: String = ""
  var full: [ScheduleState] = []

  init?(map: Map) { }

  struct ScheduleState: Mappable {
    var title: String = ""
    var week: [Int] = []

    init?(map: Map) { }

    mutating func mapping(map: Map) {
      title <- map["title"]
      week <- map["week"]
    }
  }

  mutating func mapping(map: Map) {
    short <- map["short"]
    full <- map["full"]
  }
}

struct Contacts: Mappable {
  var phone: String = ""
  var web: URL? = nil

  init?(map: Map) { }

  mutating func mapping(map: Map) {
    phone <- map["phone"]
    web <- (map["web"], URLTransform())
  }
}

struct ReviewsState: Mappable {
  var data: [Review] = []
  var qty: Int = 0
  var rating: Float = 0
  var pagination : Pagination? = nil

  init?(map: Map) { }

  mutating func mapping(map: Map) {
    data <- map["data"]
    pagination <- map["pagination"]
    qty <- map["qty"]
    rating <- map["rating"]
  }
}

struct Address: Mappable {
  var city: String = ""
  var metro: String = ""
  var street: String = ""

 init?(map: Map)  { }

  mutating func mapping(map: Map) {
    city <- map["city"]
    metro <- map["metro"]
    street <- map["street"]
  }

}

class Review: Mappable {
  var id: Int = 0
  var user: String = ""
  var date: Date = Date()
  var text: String = ""
  var interesting: Int = 0
  var convenient: Int = 0
  var imgs: [URL] = []

  required init?(map: Map) {
  }

  func mapping(map: Map) {
    id <- map["id"]
    user <- map["attributes.user"]
    date <- (map["attributes.date"], DateTransform())
    text <- map["attributes.text"]
    interesting <- (map["attributes.interesting"], IdTransform())
    convenient <- (map["attributes.convenient"], IdTransform())
    user <- map["attributes.user"]
    imgs <- (map["links.imgs"], URLTransform())
    
  }
}
