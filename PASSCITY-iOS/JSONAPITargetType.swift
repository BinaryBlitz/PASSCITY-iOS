//
//  JSONAPITargetType.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

// Custom target type. Extension contains default values
protocol JSONAPITargetType: TargetType {
}

extension JSONAPITargetType {
  var baseURL: URL {
    return URL(string: "https://passcity.ru/api/mobile_app")!
  }

  var parameterEncoding: ParameterEncoding {
    switch method {
    case .put, .post, .patch:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }

  var task: Task {
    return .request
  }

  var sampleData: Data {
    return Data()
  }
}
