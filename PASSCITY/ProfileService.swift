//
//  ProfileService.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

class ProfileService {
  static let instance = ProfileService()

  private let authProvider = JSONAPIProvider<AuthenticationTarget>()
  private let itemsProvider = JSONAPIProvider<AvailableItemsTarget>()

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

  private(set) var currentSettings: Settings? = nil
  private(set) var currentCard: PassCityCard? = nil

  var cardInputTriesLeft = 3

  func validateLoginResponseData(data: LoginData) {
    let currentAV = Float(currentLoginData.av ?? "") ?? 1
    let backendAV = Float(data.av ?? "") ?? currentAV
    if backendAV != currentAV {
      DispatchQueue.main.async {
        RootViewController.instance?.setAppUpdate()
      }
    } else if (data.uid == nil || data.uid == 0) && isAuthorized {
      /*isAuthorized = false
      DispatchQueue.main.async {
        RootViewController.instance?.setRegistration()
      }*/
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
      loginInternalData = LoginData.new
    }
  }

  private init() {
    self.loginInternalData = LoginData.current
    self.currentSettings = Settings.current
    self.currentCard = PassCityCard.current
  }

  func logout() {
    try? StorageHelper.save(nil, forKey: .currentSettings)
    try? StorageHelper.save(nil, forKey: .currentCard)
    try? StorageHelper.save(nil, forKey: .currentProfile)
    isAuthorized = false
    RootViewController.instance?.setRegistration()
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

  func checkCode(code: String, completion: ServiceCompletion<Void>?) {
    var loginData = currentLoginData

    authProvider.callAPI(.checkCode(data: loginData, code: code)) { result in
      switch result {
      case .success(let response):
        loginData.kid = response.login?.kid
        loginData.client = response.login?.client
        self.loginInternalData = loginData
        if var settings = Mapper<Settings>().map(JSONObject: response.data) {
          self.currentSettings = settings
          settings.language = Language(rawValue: Locale.preferredLanguages.first ?? "en")
          try? StorageHelper.save(settings.toJSONString(), forKey: .currentSettings)
        }
        completion?(.success())
      case .failure(let error):
        completion?(.failure(error))
      }
    }
  }

  func getSettings(completion: @escaping ServiceCompletion<Void>) {
    guard isAuthorized else {
      return
    }

    itemsProvider.callAPI(.getSettings) { result in
      switch result {
      case .success(let response):
        if let settings = Mapper<Settings>().map(JSONObject: response.data) {
          self.currentSettings = settings
          try? StorageHelper.save(settings.toJSONString(), forKey: .currentSettings)
        }
        completion(.success())
      case .failure(let error):
        completion(.failure(error))
      }

    }
  }

  func updateSettings(_ settings: Settings, _ completion: @escaping ServiceCompletion<Void>) {
    guard isAuthorized else {
      return
    }

    itemsProvider.callAPI(.updateSettings(settings)) { result in
      switch result {
      case .success(_):
        self.currentSettings = settings
        try? StorageHelper.save(settings.toJSONString(), forKey: .currentSettings)
        completion(.success())
      case .failure(let error):
        completion(.failure(error))
      }

    }
  }


  func fetchCard(_ completion: @escaping ServiceCompletion<PassCityCard>) {
    itemsProvider.callAPI(.getCard) { result in
      switch result {
      case .success(let response):
        guard let card = Mapper<PassCityCard>().map(JSONObject: response.data) else {
          return completion(.failure(DataError.serializationError(response.data)))
        }
        self.currentCard = card
        try? StorageHelper.save(card.toJSONString(), forKey: .currentCard)
        return completion(.success(card))
      case .failure(let error):
        return completion(.failure(error))
      }
    }
  }
}
