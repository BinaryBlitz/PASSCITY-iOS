//
//  URL+appendingQueryParams.swift
//  PASSCITY
//
//  Created by Алексей on 10.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

extension URL {

  func appendingQueryParams(parameters: [String: String]?) -> URL {
    guard
      let parameters = parameters,
      let urlComponents = NSURLComponents(url: self, resolvingAgainstBaseURL: true) else {
        return self
    }

    var mutableQueryItems: [URLQueryItem] = urlComponents.queryItems ?? []

    mutableQueryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0, value: $1) })
    urlComponents.queryItems = mutableQueryItems

    return urlComponents.url!
  }

}
