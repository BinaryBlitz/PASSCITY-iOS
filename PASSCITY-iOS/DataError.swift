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
  case jsonAPIErrors([JSONAPIResponseError])

  var description: String {
    switch self {
    case .moyaError(let error):
      return error.errorDescription ?? ""
    case .serializationError(_):
      return "Ошибка обработки ответа сервера"
    case .jsonAPIErrors(let errors):
      var description = ""
      errors.enumerated().forEach { (index, error) in
        description += error.detail
        if index < errors.count - 1 {
          description += "\n"
        }
      }
      return description
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
    private(set) var status: String = ""
    private(set) var detail: String = ""
    private(set) var message: String = ""
    private(set) var code: Code? = nil
    private(set) var model: [String: Any]  = [:]
    private(set) var source: [String: String]  = [:]

    var description: String? {
      if !detail.isEmpty {
        return detail
      }
      if !message.isEmpty {
        return message
      }
      return nil
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
      status <- map["status"]
      detail <- map["detail"]
      message <- map["message"]
      source <- map["source"]
      code <- (map["code"], EnumTransform<Code>())
      model <- map["model"]
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
