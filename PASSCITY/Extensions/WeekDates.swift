//
//  WeekDates.swift
//  PASSCITY
//
//  Created by Алексей on 03.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

enum WeekDays: Int {
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday

  var shortName: String {
    switch self {
    case .monday:
      return "Пн"
    case .tuesday:
      return "Вт"
    case .wednesday:
      return "Ср"
    case .thursday:
      return "Чт"
    case .friday:
      return "Пт"
    case .saturday:
      return "Сб"
    case .sunday:
      return "Вс"
    }
  }

  var color: UIColor {
    switch self {
    case .monday:
      return .frogGreen
    default:
      return .red
    }
  }

    static let allValues = [monday, monday, tuesday, wednesday, thursday, friday, saturday]
}
