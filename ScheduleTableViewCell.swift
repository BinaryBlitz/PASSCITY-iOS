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
  let weekViews = 	UIView()
  let schedulesView = UIStackView()
  let closeButton = UIButton()

  var isExpandedHanlder: (() -> Void)? = nil

  var isExpanded: Bool = false {
    didSet {
      isExpandedHanlder?()
    }
  }

  func confure(_ item: PassCityFeedItem) {
    titleLabel.text = item.shortSchedule.isEmpty ? item.schedule : item.shortSchedule
    descriptionLabel.text = item.description
	descriptionLabel.numberOfLines = 3
	schedulesView.spacing = 8
    guard let scheduleState: ScheduleState = item.fullSchedule else { return }

    for (offset, day) in scheduleState.full.enumerated() {
      if let view = schedulesView.arrangedSubviews[safe: offset] as? AvailableWeekView {
        view.configure(time: day.title, days: day.week)
      } else {
        let scheduleView = AvailableWeekView(text: day.title, days: day.week)
        scheduleView <- [
			Left(),
			Height(20),
			Right()
		]

        scheduleView.backgroundColor = offset%2 == 0 ? .white20 : .white
        schedulesView.addArrangedSubview(scheduleView)
		layoutIfNeeded()
		updateFocusIfNeeded()
      }
    }
  }

  init() {
    super.init(style: .default, reuseIdentifier: nil)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupView() {
	selectionStyle = .none
    addSubview(titleLabel)
	addSubview(schedulesView)
	addSubview(descriptionLabel)
	addSubview(closeButton)
	titleLabel.adjustsFontSizeToFitWidth = true	

    titleLabel.font = UIFont.systemFont(ofSize: 9)
    titleLabel <- [
      Top(16),
      CenterX()
    ]
	schedulesView.axis = .vertical
	schedulesView.distribution = .equalSpacing
	schedulesView <- [
		Top(20).to(titleLabel),
		Left(20),
		Height(>=30),
		Right(10)
	]

	descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
	descriptionLabel <- [
		Top(20).to(schedulesView, .bottom),
		Height(20),
		Left(20),
		Right(20),
		CenterX()
	]

    closeButton.setImage(#imageLiteral(resourceName: "iconNavbarClose"), for: .normal)

    closeButton <- [
      Top(20).to(descriptionLabel, .bottom),
      Bottom(20),
      Height(20),
      CenterX()
    ]
  }
}
