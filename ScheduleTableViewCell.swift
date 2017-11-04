//
//  ScheduleTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 04.11.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

extension Collection {

  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

class ScheduleTableViewCell: UITableViewCell {
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let schedulesView = UIStackView()
  let closeButton = UIButton()

  var isExpandedHanlder: (() -> Void)? = nil

  var isExpanded: Bool = false {
    didSet {
      isExpandedHanlder?()
    }
  }

  func configure(_ item: PassCityFeedItem) {
    titleLabel.text = item.shortSchedule.isEmpty ? item.schedule : item.shortSchedule
    guard let scheduleState: ScheduleState = item.fullSchedule else { return }

    for (offset, _) in schedulesView.arrangedSubviews.enumerated() {
      if offset >= scheduleState.full.count {
        let view = schedulesView.arrangedSubviews[offset]
        schedulesView.removeArrangedSubview(view)
        view.removeFromSuperview()
      }
    }
    for (offset, day) in scheduleState.full.enumerated() {
      if let view = schedulesView.arrangedSubviews[safe: offset] as? AvailableWeekView {
        view.configure(time: day.title, days: day.week)
      } else {
        let scheduleView = AvailableWeekView(text: day.title, days: day.week)
        schedulesView.addArrangedSubview(scheduleView)
      }
    }
  }

  func setupView() {
    addSubview(titleLabel)
    titleLabel.font = UIFont.systemFont(ofSize: 13)
    titleLabel <- [
      Top(16),
      CenterX()
    ]

    addSubview(schedulesView)
    schedulesView <- [
      Top(20),
      Left(20),
      Right(20)
    ]

    addSubview(descriptionLabel)

    descriptionLabel <- [
      Top(20).to(schedulesView)
    ]

    closeButton.setImage(#imageLiteral(resourceName: "iconNavbarClose"), for: .normal)

    closeButton <- [
      Top().to(descriptionLabel)
    ]
  }
}
