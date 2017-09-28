//
//  AuthorizationPlugin.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Moya
import Result

public struct BearerTokenPlugin: PluginType {

  static var token: String? {
    get {
      let accessToken: String? = StorageHelper.loadObjectForKey(.accessToken)
      return accessToken
    }
    set {
      try? StorageHelper.save(token, forKey: .accessToken)
    }
  }

  public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

    var request = request
    if let params = request.httpBody as? [String: Any] {
      request.addValue(authVal, forHTTPHeaderField: "Authorization")
    }

    return request
  }
}
