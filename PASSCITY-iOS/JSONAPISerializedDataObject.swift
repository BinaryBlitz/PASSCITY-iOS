//
//  JSONAPISerializedDataObject.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class JSONAPISerializedObject: Mappable {
  private(set) var data: JSONAPISerializationData? = nil
  private(set) var included: [JSONAPIResourceObject]? = nil
  private(set) var meta: [String: Any]? = nil
  private(set) var error: DataError.JSONAPIResponseError? = nil

  /// Returns Serialized JSON, suitable for use with ObjectMapper
  var serializedObject: Any? {
    return data?.serializedData(includedEntities: included ?? [])
  }

  required init?(map: Map) { }

  func mapping(map: Map) {
    included <- map["included"]
    meta <- map["meta"]
    data <- (map["data"], JSONAPISerializationData.Transform())
    error <- map["error"]
  }
}

enum JSONAPISerializationData {
  case array([JSONAPIResourceObject])
  case object(JSONAPIResourceObject)

  func serializedData(includedEntities: [JSONAPIResourceObject] = []) -> Any? {
    switch self {
    case .array(let objects):
      return objects.map { $0.serialize(includedEntities: includedEntities) }
    case .object(let object):
      return object.serialize(includedEntities: includedEntities)
    }
  }

  struct Transform: TransformType {
    typealias Object = JSONAPISerializationData
    typealias JSON = Any?

    func transformFromJSON(_ value: Any?) -> Object? {
      guard let value = value else { return nil }
      if let objects = Mapper<JSONAPIResourceObject>().mapArray(JSONObject: value) {
        return .array(objects)
      } else {
        guard let object = Mapper<JSONAPIResourceObject>().map(JSONObject: value) else { return nil }
        return .object(object)
      }
    }

    func transformToJSON(_ value: Object?) -> JSON? {
      return value?.serializedData()
    }
    
  }
}
