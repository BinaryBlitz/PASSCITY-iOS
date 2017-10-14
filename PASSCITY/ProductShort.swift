//
//  ProductShort.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

enum PassCityProductType: String {
  case package = "package"
  case ticket = "ticket"
}

class PassCityProduct: Mappable, Hashable {
  var id: Int = 0
  var title: String = ""
  var type: PassCityProductType = .package
  var category: Int = 0
  var subTitle: String = ""
  var tariff: String = ""
  var valid: String = ""
  var imgURL: URL? = nil

  // Full
  var imgs: [URL] = []
  var categories: [Category] = []
  var offer: URL? = nil

  var categoryObject: Category? {
    let categories = ProfileService.instance.currentSettings?.allCategories
    return categories?.first { $0.id == category }
  }

  required init?(map: Map) {
  }

  init() {

  }

  func mapping(map: Map) {
    id <- (map["id"], IdTransform())
    type <- (map["type"], EnumTransform<PassCityProductType>())
    title <- map["attributes.title"]
    category <- map["attributes.category"]
    subTitle <- map["attributes.sub-title"]
    tariff <- map["attributes.tariff"]
    valid <- map["attributes.valid"]
    imgURL <- (map["links.icon"], URLTransform())

    categories <- map["relationships.categories"]
    imgs <- (map["links.imgs"], URLTransform())
    offer <- (map["links.offer"], URLTransform())
  }

  var hashValue: Int {
    return id
  }

  static func ==(lhs: PassCityProduct, rhs: PassCityProduct) -> Bool {
    return lhs.id == rhs.id
  }

}
