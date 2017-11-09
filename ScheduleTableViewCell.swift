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
  let weekViews = 	UIView()
  let schedulesView = UIStackView()
  let expandButton = UIButton()
  let closeButton = UIButton()

  var isExpandedHanlder: (() -> Void)? = nil
  var isExpandedConstraint: NSLayoutConstraint? = nil

  var isExpanded: Bool = false {
    didSet {
		easy_reload()
		schedulesView.isHidden = !isExpanded
		layoutIfNeeded()
		updateConstraints()
		isExpandedHanlder?()
    }
  }

  func confure(_ item: PassCityFeedItem) {
	titleLabel.text = item.fullSchedule?.short ?? (item.shortSchedule.isEmpty ? item.schedule : item.shortSchedule)
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

	easy_reload()
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
	addSubview(expandButton)
	addSubview(closeButton)

    titleLabel.font = UIFont.systemFont(ofSize: 13)
    titleLabel <- [
      Top(16).with(.high),
      CenterX()
    ]

	expandButton <- [
		Top(5).to(titleLabel),
		CenterX()
	]

	schedulesView.axis = .vertical
	schedulesView.distribution = .equalSpacing
	schedulesView.isHidden = isExpanded
	schedulesView <- [
		Top(20).to(expandButton),
		Left(20),
		Right(10)
	  ]
	isExpandedConstraint = schedulesView.heightAnchor.constraint(equalToConstant: 0)
	isExpandedConstraint?.isActive = false

	expandButton.setImage(#imageLiteral(resourceName: "handle"), for: .normal)
	closeButton.setImage (#imageLiteral(resourceName: "iconNavbarClose"), for: .normal)
	closeButton.addTarget(self, action: #selector(toggleExpandButton), for: .touchUpInside)

    closeButton <- [
	  Top(20).to(schedulesView),
      Bottom(20),
      Height(20),
      CenterX()
    ]
  }

	func toggleExpandButton() {
		isExpanded = !isExpanded
	}
}
