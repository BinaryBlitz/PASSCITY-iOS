//
//  DateTransform.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

struct DateTimeTransform: TransformType {
  let type: Date.DateStringFormatType

  init(type: Date.DateStringFormatType = .dateTime) {
    self.type = type
  }

  typealias Object = Date
  typealias JSON = String

  public func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else { return nil }
    return Date.fromString(string: value, type: type)

  }

  public func transformToJSON(_ value: Object?) -> JSON? {
    guard let date = value else { return "" }
    return date.toString(type: type)
  }

}
