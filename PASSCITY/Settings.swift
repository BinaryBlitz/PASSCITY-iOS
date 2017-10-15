//
//  Settings.swift
//  PASSCITY
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

struct Settings: Mappable {
  var categoriesDict: [String: Category] = [:] {
    didSet {
      categories = Array(categoriesDict.values)
    }
  }
  var categories: [Category] = []
  var notifications: NotificationsSettings = NotificationsSettings()
  var language: Language? = nil
  var shopUrl: URL? = nil
  var serverUpdatePeriod: IntInterval = IntInterval()

  init?(map: Map) {
  }

  var allCategories: [Category] {
    return categories.reduce([], { (result, category) -> [Category] in
      var result = result
      result.append(category)
      category.children.forEach { child in
        child.color = child.color ?? category.color
        child.icon = child.icon ?? category.icon
        result.append(child)
      }
      return result
    })
  }

  static var current: Settings? {
    let loginDataJSON: String = StorageHelper.loadObjectForKey(.currentSettings) ?? ""
    var settings = Mapper<Settings>().map(JSONString: loginDataJSON)
    if settings?.language == nil {
      settings?.language = Language(rawValue: Locale.preferredLanguages.first ?? "en") ?? .en
    }
    return settings
  }

  mutating func mapping(map: Map) {
    categoriesDict <- map["categories"]
    notifications <- map["notifications"]
    language <- (map["language"], EnumTransform<Language>())
    shopUrl <- (map["shop_url"], URLTransform())
    serverUpdatePeriod <- map["server_update_period"]
  }

  class NotificationsSettings: Mappable {
    var servicesNearMe: Int = 0
    var newProductsNearMe: Int = 0
    var distance: Int = 1000

    init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
      servicesNearMe <- map["services_near_me"]
      newProductsNearMe <- map["new_products_near_me"]
      distance <- map["distance"]
    }
  }
}

enum Language: String {
  case ru = "ru"
  case en = "en"
  case cn = "cn"

  var name: String {
    switch self {
    case .ru:
      return "Русский (Ru)"
    case .en:
      return "English (En)"
    case .cn:
      return "Chinese (Cn)"
    }
  }

  static let allValues = [ru, en, cn]
}
