//
//  DataError.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

enum DataError: Swift.Error, CustomStringConvertible {
  case moyaError(MoyaError)
  case customError(description: String)
  case noData
  case serializationError(Any?)
  case jsonAPIError(JSONAPIResponseError)

  var description: String {
    switch self {
    case .moyaError(let error):
      return error.errorDescription ?? ""
    case .serializationError(_):
      return "Ошибка обработки ответа сервера"
    case .jsonAPIError(let error):
      return error.msg
    case .customError(let description):
      return description
    default:
      return "Ошибка сервера"
    }
  }

  var localizedDescription: String {
    return description
  }

  class JSONAPIResponseError: Mappable {
    private(set) var id: String = ""
    private(set) var msg: String = ""
    private(set) var code: Code? = nil

    required init?(map: Map) { }

    func mapping(map: Map) {
      id <- map["status"]
      msg <- map["message"]
      code <- (map["id"], EnumTransform<Code>())
    }

    enum Code: String {
      case noSubscription = "err.no_subscription"
      case phoneNotVerified = "err.phone_is_not_verified"
      case maxBookingsPerStudio = "err.max_bookings_per_studio"
      case timeCollision = "err.time_collision"
      case verif3DSRequired = "err.3dsRequired"
    }
  }
}
