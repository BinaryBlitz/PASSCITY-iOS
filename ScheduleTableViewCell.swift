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


  var isExpandedConstraint: NSLayoutConstraint? = nil

  var isExpanded: Bool = false {
    didSet {
		isExpandedConstraint?.isActive = !isExpanded
		schedulesView.isHidden = !isExpanded
		easy_reload()
		layoutIfNeeded()
		updateConstraints()
      isExpandedHanlder?()
    }
  }

  func confure(_ item: PassCityFeedItem) {
    titleLabel.text = item.shortSchedule.isEmpty ? item.schedule : item.shortSchedule
	descriptionLabel.textAlignment = .center
    descriptionLabel.text = item.fullSchedule?.short ?? item.schedule
	descriptionLabel.numberOfLines = 0
	schedulesView.spacing = 8
	schedulesView.isHidden = !isExpanded
	isExpandedConstraint?.isActive = !isExpanded
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
	  addSubview(closeButton)

    titleLabel.font = UIFont.systemFont(ofSize: 9)
    titleLabel <- [
      Top(16).with(.high),
      CenterX(),
      Bottom(>=10).to(closeButton)
    ]
	schedulesView.axis = .vertical
	schedulesView.distribution = .equalSpacing
	schedulesView <- [
		Top(20).to(titleLabel, .bottom),
		Left(20),
		Right(10)
	]

	isExpandedConstraint = schedulesView.heightAnchor.constraint(equalToConstant: 1)
	isExpandedConstraint?.priority = UILayoutPriorityRequired
	schedulesView.isHidden = isExpanded
	isExpandedConstraint?.isActive = !isExpanded
	schedulesView.isHidden = !isExpanded

	closeButton.setImage ( isExpanded ? #imageLiteral(resourceName: "iconNavbarClose") : #imageLiteral(resourceName: "handle"), for: .normal)

	closeButton.addTarget(self, action: #selector(toggleExpandButton), for: .touchUpInside)

    closeButton <- [
      Top(20).to(schedulesView, .bottom).with(.medium),
      Bottom(20),
      Height(20),
      CenterX()
    ]
  }

	func toggleExpandButton() {
		isExpanded = !isExpanded
		isExpandedHanlder?()
	}
}
