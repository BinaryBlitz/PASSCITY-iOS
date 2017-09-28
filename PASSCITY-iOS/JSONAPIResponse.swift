//
//  JSONAPIResponse.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class JSONAPIResponse {
  private let response: Moya.Response?
  private let serializedDataObject: JSONAPISerializedObject?

  var meta: [String: Any?] {
    return serializedDataObject?.meta ?? [:]
  }

  var serializedData: Any? {
    return serializedDataObject?.serializedObject
  }

  var data: Any? {
    return response?.data
  }

  var error: DataError? {
    do {
      guard let moyaResponse = response else { return .noData }
      _ = try moyaResponse.filterSuccessfulStatusCodes()
      return nil
    } catch let moyaError {
      if let jsonAPIError = serializedDataObject?.error {
        return .jsonAPIError(jsonAPIError)
      } else {
        guard let moyaError = moyaError as? MoyaError else { return .noData }
        return .moyaError(moyaError)
      }
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
