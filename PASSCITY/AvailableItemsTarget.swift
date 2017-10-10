//
//  AvailableItemsTarget.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Moya

enum AvailableItemsTarget: JSONAPITargetType {
  case getMap(EventsFiltersState)
  case getAnnounces(EventsFiltersState)
  case getProducts(ProductsFiltersState)
  case getSettings

  var path: String {
    switch self {
    case .getMap(_):
      return "map"
    case .getAnnounces(_):
      return "announces"
    case .getProducts:
      return "products"
    case .getSettings:
      return "settings"
    }
  }

  var includeLogin: Bool {
    return true
  }

  var method: Moya.Method {
    return .get
  }

  var jsonAPIParams: [String : Any]? {
    switch self {
    case .getMap(let filters):
      return filters.toJSON()
    case .getAnnounces(let filters):
      return filters.toJSON()
    case .getProducts(let filters):
      return filters.toJSON()
    case .getSettings:
      return nil
    }
  }
}

