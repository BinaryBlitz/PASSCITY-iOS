//
//  JSONAPISerializedDataObject.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class JSONAPISerializedObject: Mappable {
  private(set) var login: LoginData? = nil
  private(set) var data: [String: Any]? = nil
  private(set) var error: DataError.JSONAPIResponseError? = nil

  required init?(map: Map) { }

  func mapping(map: Map) {
    login <- map["login"]
    data <- map["data"]
    error <- map["error"]
  }
}
