//
//  JSONAPIResponse.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class JSONAPIResponse {
  private let response: Moya.Response?
  private let serializedDataObject: JSONAPISerializedObject?

  var login: LoginData? {
    return serializedDataObject?.login
  }

  var data: Any? {
    return serializedDataObject?.data
  }

  var error: DataError? {
    do {
      guard let moyaResponse = response else { return .noData }
      if let jsonAPIError = serializedDataObject?.error, jsonAPIError.id != 0 {
        return .jsonAPIError(jsonAPIError)
      }
      _ = try moyaResponse.filterSuccessfulStatusCodes()
      return nil
    } catch let moyaError {
      guard let moyaError = moyaError as? MoyaError else { return .noData }
      return .moyaError(moyaError)
    }
  }

  var statusCode: Int? {
    return response?.statusCode
  }

  init(_ response: Moya.Response?) {
    self.response = response

    guard let json = try? response?.mapJSON() else {
      self.serializedDataObject = nil
      return
    }
    self.serializedDataObject = Mapper<JSONAPISerializedObject>().map(JSONObject: json)
  }
}
