//
//  NetworkActivityIndicator.swift
//  PASSCITY
//
//  Created by Алексей on 28.09.17.
//  Copyright © 2017 PASSCITY. All rights reserved.
//

import Foundation
import UIKit

public class NetworkActivityIndicator: NSObject {
  public static let sharedIndicator = NetworkActivityIndicator()
  var activitiesCount = 0

  public var visible: Bool = false {
    didSet {
      if visible {
        self.activitiesCount += 1
      } else {
        self.activitiesCount -= 1
      }

      if self.activitiesCount < 0 {
        self.activitiesCount = 0
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = (self.activitiesCount > 0)
      }

    }
  }
}
