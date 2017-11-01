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

class AvailableWeekView: UIView {
  let timeLabel = UILabel()

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
    weekDatesStackView.alignment = .trailing
    weekDatesStackView.spacing = 4
    WeekDays.allValues.forEach { day in
      let view = DayWeekView(color: day.color, text: day.shortName)
      view <- Size(22)
      weekDatesStackView.addArrangedSubview(view)
    }

    addSubview(timeLabel)

    timeLabel <- [
      Left(30),
      CenterY()
    ]
    weekDatesStackView.backgroundColor = .clear
    addSubview(weekDatesStackView)
    weekDatesStackView <- [
      Left(>=30),
      Right(30),
      CenterY()
    ]
  }

  func configure(time: String, days: [Int]) {
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
