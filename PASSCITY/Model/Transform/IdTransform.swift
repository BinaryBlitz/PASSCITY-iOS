//
//  IdTransform.swift
//  PASSCITY
//
//  Created by Алексей on 09.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct IdTransform: TransformType {
  typealias Object = Int
  typealias JSON = Any

  public func transformFromJSON(_ value: Any?) -> Object? {
    if let value = value as? String {
      return Int(value)
    } else if let value = value as? Int {
      return value
    }
    return UUID().hashValue
  }

  public func transformToJSON(_ value: Object?) -> JSON? {
    return value
  }

}
