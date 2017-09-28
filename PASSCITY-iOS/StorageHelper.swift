//
//  StorageHelper.swift
//  PASSCITY-iOS
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import KeychainAccess

class StorageHelper {

  enum StorageError: Error {
    case keychainOnlyStringSupported
  }

  enum StorageType {
    case keychain
    case userDefaults
  }

  enum StorageKey: String {
    case currentProfile
    case accessToken
    case currentCity
    case futureBookings
    case pastBookings
    case favoriteStudios

    var storageType: StorageType {
      switch self {
      case .accessToken:
        return .keychain
      default:
        return .userDefaults
      }
    }
  }

  static func save(_ object: Any?, forKey key: StorageKey) throws {
    switch key.storageType {
    case .keychain:
      let keychain = Keychain()
      if object == nil {
        try? keychain.remove(key.rawValue)
      } else {
        guard let objectString = object as? String else { throw StorageError.keychainOnlyStringSupported }
        keychain[key.rawValue] = objectString
      }
    case .userDefaults:
      let userDefaults = UserDefaults.standard
      userDefaults.set(object, forKey: key.rawValue)
    }
  }

  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    switch key.storageType {
    case .keychain:
      let keychain = Keychain()
      let object = keychain[key.rawValue]
      return object as? T
    case .userDefaults:
      let userDefaults = UserDefaults.standard
      let object = userDefaults.object(forKey: key.rawValue)
      return object as? T
    }
  }
}
