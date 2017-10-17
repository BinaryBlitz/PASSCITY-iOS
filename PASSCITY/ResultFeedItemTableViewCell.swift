//
//  FeedItemsItemTableViewCell.swift
//  PASSCITY
//
//  Created by Алексей on 16.10.17.
//  Copyright © 2017 PASSCITY-iOS-TEST. All rights reserved.
//

import Foundation
import UIKit

class ResultFeedItemTableViewCell: UITableViewCell {
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconView: UIImageView!
  @IBOutlet weak var distationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  @IBAction func moreButtonAction(_ sender: Any?) {
    moreButtonHandler?()
  }

  var moreButtonHandler: (() -> Void)? = nil

  func configure(_ item: PassCityFeedItemShort) {
    iconView.kf.setImage(with: item.imgURL)
    titleLabel.text = item.title
    distationLabel.text = item.distance
    dateLabel.text = item.schedule.isEmpty ? item.dates : item.schedule

    layoutIfNeeded()
    updateConstraints()
  }

}
