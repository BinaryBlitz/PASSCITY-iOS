//
//  Card.swift
//  PASSCITY
//
//  Created by Алексей on 14.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import ObjectMapper

class PassCityCard: Mappable, Hashable {
  var id: Int = 0
  var code: String = ""
  var bonusAccrued: String = ""
  var bonusCharged: String = ""
  var bonusBalance: String = ""
  var userAttributes: [UserAttribute] = []

  var promoCode: String = ""
  var promoCodeUsed: Int = 0
  var balance: String = ""
  var docs: [Doc] = []

  static var current: PassCityCard? {
    let cardDataJSON: String = StorageHelper.loadObjectForKey(.currentCard) ?? ""
    let card = Mapper<PassCityCard>().map(JSONString: cardDataJSON)
    return card
  }

  required init?(map: Map) {
  }

  init() {

  }

  func mapping(map: Map) {
    id <- (map["id"], IdTransform())
    code <- map["attributes.code"]
    bonusAccrued <- map["attributes.bonus.accrued"]
    bonusCharged <- map["attributes.bonus.charged"]
    bonusBalance <- map["attributes.bonus.balance"]
    promoCode <- map["attributes.promo.code"]
    promoCodeUsed <- map["attributes.promo.used"]
    balance <- map["attributes.balance"]
    userAttributes <- map["relationships.owner.attributes"]
    docs <- map["links.docs"]
  }

  var hashValue: Int {
    return id
  }

  static func ==(lhs: PassCityCard, rhs: PassCityCard) -> Bool {
    return lhs.id == rhs.id
  }

  class Doc: Mappable {
    var title: String = ""
    var url: URL? = nil

    required init?(map: Map) {
    }

    func mapping(map: Map) {
      title <- map["title"]
      url <- (map["url"], URLTransform())

    }
  }

  class UserAttribute: Mappable {
    var title: String = ""
    var value: String = ""

    required init?(map: Map) {
    }

    func mapping(map: Map) {
      title <- map["title"]
      value <- map["value"]

    }
  }


}
