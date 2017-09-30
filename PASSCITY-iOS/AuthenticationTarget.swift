//
//  AuthenticationTarget.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 29.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Moya

enum AuthenticationTarget: JSONAPITargetType {
  case register(LoginData, sendCode: Bool)
  case checkCode(data: LoginData, code: String)

  var includeLogin: Bool {
    return false
  }

  var path: String {
    return "auth"
  }

  var method: Moya.Method {
    switch self {
    case .register(_):
      return .get
    case .checkCode(_,_):
      return .post
    }
  }

  var jsonAPIParams: [String : Any]? {
    switch self {
    case .register(let loginData, let sendCode):
      var json = loginData.toJSON()
      if sendCode {
        json.removeValue(forKey: "barcode")
      }
      return json
    case .checkCode(let loginData, let code):
      var json = loginData.toJSON()
      json["code"] = code
      return json
    }
  }
}
