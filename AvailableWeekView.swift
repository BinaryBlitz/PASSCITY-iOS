//
//  AvailableWeekView.swift
//  PASSCITY
//
//  Created by Алексей on 03.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

enum ExpoHeaderItem: Int {
  case address
  case announces
  case instructions
  case ratings

  var name: String {
    switch self {
    case .address:
      return "Адрес"
    case .announces:
      return "Афиша"
    case .instructions:
      return "Инструкции"
    case .ratings:
      return "Отзывы"
    }
  }
  static let allValues = [address, announces, instructions, ratings]

}

enum EventHeaderItem: Int {
  case location
  case ratings

  var name: String {
    switch self {
    case .location:
      return "Где происходит"
    case .ratings:
      return "Отзывы"
    }
  }

  static let allValues = [location, ratings]
}


class AvailableWeekView: UIView {
  let timeLabel = UILabel()
  let expandButton = UIButton()
  var weekDatesiews: [DayWeekView] {
    return weekDatesStackView.arrangedSubviews.map { $0 as! DayWeekView }
  }

  let weekDatesStackView = UIStackView()

  init(text: String, days: [Int]) {
    super.init(frame: CGRect.null)
    setup()
    configure(time: text, days: days)
  }

  func setup() {
    weekDatesStackView.axis = .horizontal
    weekDatesStackView.alignment = .center
    weekDatesStackView.spacing = 4
    WeekDays.allValues.forEach { day in
      let view = DayWeekView(color: day.color, text: day.shortName)
      view <- Size(22)
	  view.cornerRadius = 11
      weekDatesStackView.addArrangedSubview(view)
    }

    addSubview(timeLabel)
	timeLabel.font  = UIFont.systemFont(ofSize: 16)
    timeLabel <- [
      Left(0),
      Top(3),
      Bottom(3)
    ]
    weekDatesStackView.backgroundColor = .clear
    addSubview(weekDatesStackView)
    weekDatesStackView <- [
      Left(20).to(timeLabel),
      Right(30),
      Height(30),
      CenterY()
    ]
  }

  func configure(time: String, days: [Int]) {
    timeLabel.text = time

    days.enumerated().forEach { [weak self] offset, value in
      self?.weekDatesiews[offset].isHidden = value == -1
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class DayWeekView: UIView {
  let label = UILabel()
  init(color: UIColor = .frogGreen, text: String) {
    super.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    label.text = text
	label.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightHeavy)
    backgroundColor = color
    addSubview(label)
    label <- Center()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addSubview(label)
    label <- Center()
  }
}
