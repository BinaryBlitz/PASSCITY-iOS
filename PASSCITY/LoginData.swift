//
//  LoginData.swift
//  PASSCITY
//
//  Created by Алексей on 29.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import ObjectMapper

private let currentApplicationVersion = "1.0"

struct LoginData: Mappable {

  // User Id
  var uid: Int? = nil

  // key_id получаемое в пару от сервера к user_id в ответ на запрос "auth"
  var kid: String? = nil

  // device_id - уникальный идентификатор устройства
  var did: String? = nil

  // client - признак клиента 1(клиент), 0(новый пользователь)
  var client: Int? = nil

  // application_version - версия приложения
  var av: String? = nil
  var coordinates: Coordinates? = nil

  // User - additional data
  var name: String? = nil
  var email: String? = nil
  var phone: String? = nil
  var barcode: String? = nil

  init?(map: Map) {
    
  }

  init() { }

  mutating func mapping(map: Map) {
    uid <- map["uid"]
    kid <- map["kid"]
    did <- map["did"]
    av <- map["av"]
    client <- map["client"]
    coordinates <- map["coordinates"]

    name <- map["name"]
    email <- map["email"]
    phone <- map["phone"]
    barcode <- map["barcode"]
  }

  static var current: LoginData {
    let loginDataJSON: String = StorageHelper.loadObjectForKey(.currentProfile) ?? ""
    var loginData = Mapper<LoginData>().map(JSONString: loginDataJSON) ?? LoginData()
    loginData.av = currentApplicationVersion
    loginData.did = UIDevice.current.identifierForVendor?.uuidString

    return loginData
  }

  static var new: LoginData {
    var loginData = LoginData()
    loginData.av = currentApplicationVersion
    loginData.did = UIDevice.current.identifierForVendor?.uuidString

    return loginData
  }
}
