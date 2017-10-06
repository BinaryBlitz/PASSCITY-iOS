//
//  Date+PASSCITy.swift
//  PASSCITY
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation

extension DateFormatter {

  convenience init(dateStyle: DateFormatter.Style = DateFormatter.Style.short) {
    self.init()
    self.dateStyle = dateStyle
  }

}

extension Date {

  struct Formatter {
    static let shortDate = DateFormatter(dateStyle: .short)
    static let longDate = DateFormatter(dateStyle: .full)
    static let mediumDate = DateFormatter(dateStyle: .medium)
    static let monthMedium: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "LLL"
      return formatter
    }()
    static let monthFull: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "LLLL"
      return formatter
    }()
  }

  enum DateStringFormatType: String {
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case onlyDate = "YYYY-MM-dd"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  }

  var shortDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY"
    return formatter.string(from: self)
  }

  var time: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }

  var longDate: String {
    return Formatter.longDate.string(from: self)
  }

  var mediumDate: String {
    return Formatter.mediumDate.string(from: self)
  }

  var monthMedium: String {
    return Formatter.monthMedium.string(from: self)
  }

  var monthFull: String {
    return Formatter.monthFull.string(from: self).capitalizingFirstLetter()
  }

  func toString(type: DateStringFormatType) -> String {
    switch type {
    case .iso8601:
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions.insert(.withTimeZone)
      dateFormatter.formatOptions = .withFullDate
      return dateFormatter.string(from: self)
    default:
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = type.rawValue
      return dateFormatter.string(from: self)
    }
  }


  static func fromString(string: String, type: DateStringFormatType = .dateTime) -> Date? {
    switch type {
    case .iso8601:
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions.insert(.withTimeZone)
      dateFormatter.formatOptions = .withFullDate
      return dateFormatter.date(from: string)
    default:
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = type.rawValue
      return dateFormatter.date(from: string)
    }
  }
}

extension Date {
  var startOfDay: Date {
    return Calendar.current.startOfDay(for: self)
  }

  var endOfDay: Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return Calendar.current.date(byAdding: components, to: startOfDay)!
  }
}

extension String {
  func capitalizingFirstLetter() -> String {
    let first = String(characters.prefix(1)).capitalized
    let other = String(characters.dropFirst())
    return first + other
  }

  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
