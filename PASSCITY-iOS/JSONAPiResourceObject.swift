//
//  JSONAPiResourceObject.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

/// A Resource object(see jsonapi.org specification)
class JSONAPIResourceObject: Mappable {
  var id: String = ""
  var type: String = ""
  var attributes: [String: Any] = [:]
  var relationships: [String: JSONAPISerializedObject] = [:]

  func serialize(includedEntities: [JSONAPIResourceObject]) -> [String: Any] {
    var serializedObject = self.attributes
    guard !includedEntities.isEmpty && !relationships.isEmpty else { return serializedObject }

    for (key, relationship) in relationships {
      guard let data = relationship.data else { continue }
      switch data {
      case .array(let relationships):
        let filteredEntities = includedEntities.filter { entity in
          return relationships.first { entity.id == $0.id && entity.type == $0.type } != nil
          }.map { $0.attributes }
        serializedObject[key] = filteredEntities
      case .object(let relationship):
        serializedObject[key] = includedEntities.first { $0.id == relationship.id && $0.type == relationship.type }?.attributes
      }
    }
    return serializedObject
  }

  required init?(map: Map) {  }

  func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    attributes <- map["attributes"]
    relationships <- map["relationships"]
  }
}
