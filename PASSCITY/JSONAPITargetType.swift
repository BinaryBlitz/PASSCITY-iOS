//
//  JSONAPITargetType.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

// Custom target type. Extension contains default values
protocol JSONAPITargetType: TargetType {

  // Parameters that will be composed with login data into params object
  var jsonAPIParams: [String: Any]? { get }

  // Indicates whether login data should be included
  var includeLogin: Bool { get }
}

extension JSONAPITargetType {
  var baseURL: URL {
    return URL(string: "https://passcity.ru/api/mobile_app/v1")!
  }

  var parameterEncoding: ParameterEncoding {
    switch method {
    case .put, .post, .patch:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }

  var parameters: [String: Any]? {
    var params: [String: Any] = jsonAPIParams ?? [:]
    if includeLogin {
      params["login"] = ProfileService.instance.currentLoginData.toJSON()
    }
    let json = JSON(params).rawString(.utf8)!
    return [
      "params": parameterEncoding is JSONEncoding ? params : json,
      "test": 1
    ]
  }

  var task: Task {
    return .request
  }

  var sampleData: Data {
    return Data()
  }
}
