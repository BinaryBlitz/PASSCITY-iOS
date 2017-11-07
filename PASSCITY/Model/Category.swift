//
//  Category.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

class Category: Mappable, Hashable {
  var id: Int = 0
  var title: String = ""
  var type: String = "category"
  var parentId: Int = 0
  var selected: Int = 0
  var color: UIColor? = nil
  var children: [Category] = []
  var icon: URL? = nil

  var conditions: [String] = []
  var objects: [PassCityFeedItem] = []
  

  var fullObject: Category? {
    let categories = ProfileService.instance.currentSettings?.allCategories
    return categories?.first { $0.id == id }
  }

  var hashValue: Int {
    return id
  }

  required init?(map: Map) {
  }

 func mapping(map: Map) {
    id <- (map["id"], IdTransform())
    type <- map["type"]
    title <- map["attributes.title"]
    if map.mappingType == .fromJSON && title.isEmpty {
      title <- map["title"]
    }
    parentId <- map["attributes.parent_id"]
    selected <- map["attributes.selected"]
    children <- map["relationships.children"]
    color <- (map["attributes.color"], HexColorTransform())
    icon <- (map["links.icon"], URLTransform())
    objects <- map["objects"]
    conditions <- map["conditions"]
  }

  static func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
  }
}
