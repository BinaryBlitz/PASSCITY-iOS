//
//  ProfileService.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import Moya

class ProfileService {
  static let instance = ProfileService()

  let authProvider = JSONAPIProvider<AuthenticationTarget>()

  private var loginInternalData: LoginData {
    didSet {
      try? StorageHelper.save(loginInternalData.toJSONString(), forKey: .currentProfile)
    }
  }

  var currentLoginData: LoginData {
    var data = loginInternalData
    data.coordinates = Coordinates(LocationService.instance.currentLocation)
    return data
  }

  var cardInputTriesLeft = 3

  func validateLoginResponseData(data: LoginData) {
    let currentAV = Float(currentLoginData.av ?? "") ?? 0
    let backendAV = Float(data.av ?? "") ?? 0
    if backendAV != currentAV {
      RootViewController.instance?.setAppUpdate()
    } else if data.uid == nil || data.uid == 0 && isAuthorized {
      isAuthorized = false
      RootViewController.instance?.setRegistration()
    }
  }

  var isAuthorized: Bool {
    get {
      return currentLoginData.uid != nil
      && currentLoginData.uid != 0
      && currentLoginData.kid != nil && !(currentLoginData.kid!.isEmpty)
    }
    set {
      guard !newValue else { return }
      loginInternalData = LoginData.current
    }
  }

  private init() {
    self.loginInternalData = LoginData.current
  }

  func auth(name: String? = nil, email: String? = nil, phone: String? = nil, completion: @escaping ServiceCompletion<Void>) {
    var loginData = currentLoginData
    loginData.name = name ?? currentLoginData.name
    loginData.email = email ?? currentLoginData.email
    loginData.phone = phone ?? currentLoginData.phone

    authProvider.callAPI(.register(loginData, sendCode: true)) { result in
      switch result {
      case .success(let response):
        loginData.uid = response.login?.uid
        self.loginInternalData = loginData
        completion(.success())
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func auth(barCode: String, completion: @escaping ServiceCompletion<Void>) {
    var loginData = currentLoginData
    loginData.barcode = barCode

    authProvider.callAPI(.register(loginData, sendCode: false)) { result in
      switch result {
      case .success(let response):
        loginData.uid = response.login?.uid
        loginData.name = response.login?.name
        loginData.email = response.login?.email
        loginData.phone = response.login?.phone
        self.loginInternalData = loginData
        completion(.success())
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func checkCode(code: String, completion: @escaping ServiceCompletion<Void>) {
    var loginData = currentLoginData

    authProvider.callAPI(.checkCode(data: loginData, code: code)) { result in
      switch result {
      case .success(let response):
        loginData.kid = response.login?.kid
        loginData.client = response.login?.client
        self.loginInternalData = loginData
        completion(.success())
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
