//
//  ProfileService.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import Moya

class ProfileService {
  static let instance = ProfileService()
  private init() { }

  var isAuthorized: Bool {
    return false
  }
}
