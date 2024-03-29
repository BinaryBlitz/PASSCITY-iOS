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
  case getProduct(type: String, id: Int)
  case getSettings
  case getCard
  case updateSettings(Settings)

  var path: String {
    switch self {
    case .getMap(_):
      return "map"
    case .getAnnounces(_):
      return "announces"
    case .getProducts:
      return "products"
    case .getProduct(let type, let id):
      return "\(type)/\(id)"
    case .getSettings:
      return "settings"
    case .updateSettings(_):
      return "settings"
    case .getCard:
      return "card"
    }
  }

  var includeLogin: Bool {
    return true
  }

  var method: Moya.Method {
    switch self {
    case .updateSettings(_):
      return .post
    default:
      return .get
    }
  }

  var jsonAPIParams: [String : Any]? {
    switch self {
    case .getMap(let filters):
      return filters.toJSON()
    case .getAnnounces(let filters):
      return filters.toJSON()
    case .getProducts(let filters):
      return filters.toJSON()
    case .updateSettings(let settings):
      return [
        "data": settings.toJSON()
      ]
    case .getSettings, .getProduct(_, _), .getCard:
      return nil
    }
  }
}

