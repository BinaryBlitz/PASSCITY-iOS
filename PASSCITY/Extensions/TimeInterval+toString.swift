//
//  TimeInterval+toString.swift
//  PASSCITY
//
//  Created by Алексей on 22.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

extension TimeInterval {
  var toString: String {
    let interval = Int(self)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }

}
